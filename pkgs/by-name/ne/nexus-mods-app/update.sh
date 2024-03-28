#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
set -o errexit -o nounset -o pipefail

new_tag_name="$(curl -s 'https://api.github.com/repos/Nexus-Mods/NexusMods.App/releases?per_page=1' | jq --raw-output '.[0].tag_name')"
new_version="${new_tag_name#'v'}"
old_version="$(nix-instantiate --eval --attr nexus-mods-app.version | jq --exit-status --raw-output)"

if [[ "$new_version" == "$old_version" ]]; then
    echo "Up to date"
    exit 0
fi

update-source-version nexus-mods-app "$new_version"

"$(nix-build . -A nexus-mods-app.fetch-deps --no-out-link)"
