#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts

set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"
new_version="$(curl -s "https://api.github.com/repos/azure/bicep/releases?per_page=1" | jq -r '.[0].name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./package.nix)"

if [[ "$new_version" == "$old_version" ]]; then
    echo "Already up to date!"
    exit 0
fi

cd ../../../..
update-source-version bicep "${new_version//v/}"
"$(nix-build . -A bicep.fetch-deps --no-out-link)" "$deps_file"
