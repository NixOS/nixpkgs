#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    curl -s https://api.github.com/repos/nkallen/plasticity/releases/latest | jq -e -r ".tag_name | .[1:]")
old_version=$(nix-instantiate --eval -A plasticity.version | jq -e -r)

if [[ $version == "$old_version" ]]; then
    echo "New version same as old version, nothing to do." >&2
    exit 0
fi

update-source-version plasticity "$version"

