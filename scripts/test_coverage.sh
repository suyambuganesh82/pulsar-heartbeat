#!/bin/bash

#
# Run unit test and generate test coverage report 
#

# absolute directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

BASE_PKG_DIR="github.com/datastax/pulsar-heartbeat/src/"
ALL_PKGS=""

cd $DIR/../src
for d in */ ; do
    if [[ ${d} != "brokers/" && ${d} != "k8s/" && ${d} != "metering/" && ${d} != "topic/" ]] # exclude unit-test for test coverage
    then
        pkg=${d%/}
        ALL_PKGS=${ALL_PKGS}","${BASE_PKG_DIR}${pkg}
    fi
done

ALL_PKGS=$(echo $ALL_PKGS | sed 's/^,//')
echo $ALL_PKGS

cd $DIR/../src/

go test ./... -coverpkg=$ALL_PKGS -covermode=count -coverprofile coverage.out
# to be uploaded to covercov
cp coverage.out $DIR/../coverage.txt
go tool cover -func coverage.out > /tmp/coverage2.txt

coverPercent=$(cat /tmp/coverage2.txt | grep total: | awk '{print $3}' | sed 's/%$//g')

echo "Current test coverage is at ${coverPercent}%"
echo "TODO add code coverage verdict"
