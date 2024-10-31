#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash
set -euo pipefail

new_version="$(curl -s "https://api.github.com/repos/retrospy/RetroSpy/releases?per_page=1" | jq -r '.[0].tag_name')"
new_version=${new_version#v}
old_version=$(nix-instantiate --eval -A retrospy.version | jq -e -r)

if [[ "$new_version" == "$old_version" ]]; then
    echo "Up to date"
    exit 0
fi

update-source-version retrospy "$new_version"

eval "$(nix-build . -A retrospy.fetch-deps --no-out-link)"
