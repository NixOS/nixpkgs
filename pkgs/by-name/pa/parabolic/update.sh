#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/NickvisionApps/Parabolic/releases/latest | jq -e -r .tag_name)
old_version=$(nix-instantiate --eval -A parabolic.version | jq -e -r)

if [[ $version == "$old_version" ]]; then
    echo "New version same as old version, nothing to do." >&2
    exit 0
fi

update-source-version parabolic "$version"

$(nix-build -A parabolic.fetch-deps --no-out-link) "$(dirname -- "${BASH_SOURCE[0]}")/deps.nix"
