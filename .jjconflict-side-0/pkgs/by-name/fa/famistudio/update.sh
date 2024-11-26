#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
set -eo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

new_version="$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    -s "https://api.github.com/repos/BleuBleu/FamiStudio/releases?per_page=1" | jq -r '.[0].tag_name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"
if [[ "$new_version" == "$old_version" ]]; then
    echo "Up to date"
    exit 0
fi

cd ../../../..

if [[ "$1" != "--deps-only" ]]; then
    update-source-version famistudio "$new_version"
fi

$(nix-build . -A famistudio.fetch-deps --no-out-link) "$deps_file"
