#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -eu -o pipefail

attr=i4tools
currentVersion=$(nix-instantiate --eval --strict --attr $attr.version | tr -d '"')

api() {
    curl "https://app4.i4.cn/linuxUpdatelogJson.xhtml?type=0&pc_vs=$currentVersion"
}

info=$(api | jq -r '.[0]')
version=$(echo "$info" | jq -r '.version')
if [ "$version" = "null" ]; then
    echo "Error: Unable to fetch the latest version from the API."
    exit 1
fi
if [ "$version" = "$currentVersion" ]; then
    echo "i4tools is already at the latest version: $version"
    exit 0
fi

url=$(echo "$info" | jq -r '.urlRpm')
update-source-version $attr $version "" $url
