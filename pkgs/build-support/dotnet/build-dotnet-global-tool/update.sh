#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

attr=$UPDATE_NIX_ATTR_PATH

nixeval() {
    nix --extra-experimental-features nix-command eval --json --impure -f . "$1" | jq -r .
}

nugetName=$(nixeval "$attr.nupkg.pname")

# always skip prerelease versions for now
version=$(curl -fsSL "https://api.nuget.org/v3-flatcontainer/$nugetName/index.json" |
    jq -er '.versions | last(.[] | select(match("^[0-9]+\\.[0-9]+\\.[0-9]+$")))')

if [[ $version == $(nixeval "$attr.version") ]]; then
    echo "$attr" is already version "$version"
    exit 0
fi

update-source-version "$attr" "$version" --source-key=nupkg.src
