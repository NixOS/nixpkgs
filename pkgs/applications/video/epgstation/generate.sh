#!/usr/bin/env bash

# Script to generate the Nix package definition for EPGStation. Run this script
# when bumping the package version.

VERSION="1.7.4"
URL="https://raw.githubusercontent.com/l3tnun/EPGStation/v$VERSION/package.json"
JQ_BIN="$(nix-build ../../../.. --no-out-link -A jq)/bin/jq"

set -eu -o pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

main() {
    # update package.json
    curl -sSfL "$URL" \
        | jq '. + {"dependencies": (.devDependencies + .dependencies)} | del(.devDependencies)' \
        > package.json

    # regenerate node packages to update the actual Nix package
    pushd ../../../development/node-packages \
        && ./generate.sh
    popd

    # generate default streaming settings for EPGStation
    pushd ../../../../nixos/modules/services/video/epgstation \
        && cat "$(./generate)" > streaming.json
    popd
}

jq() {
    "$JQ_BIN" "$@"
}

main "@"
