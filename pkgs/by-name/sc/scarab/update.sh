#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
set -euo pipefail

new_version="$(curl -s "https://api.github.com/repos/fifty-six/Scarab/releases?per_page=1" | jq -r '.[0].name')"
new_version=${new_version#"v"}
old_version="$(sed -nE 's/^\s*version = "([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)";$/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
    echo "Up to date"
    exit 0
fi

update-source-version scarab "$new_version"

$(nix-build . -A scarab.fetch-deps --no-out-link)
