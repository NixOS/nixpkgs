#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq

set -eu -o pipefail

url="https://version.qgis.org/version.json"

package="$1"

function make_version {
    jq --raw-output '[.major, .minor, .patch] | join(".")'
}

if [ "$package" == "qgis" ]; then
    version="$(curl --silent $url | jq '.latest' | make_version)"
elif [ "$package" == "qgis-ltr" ]; then
    version="$(curl --silent $url | jq '.ltr' | make_version)"
fi

update-source-version "$package" "$version"
