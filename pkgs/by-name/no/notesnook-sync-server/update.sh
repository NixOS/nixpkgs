#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

set -x

version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/streetwriters/notesnook-sync-server/tags | jq -e -r '.[0].name')
old_version=$(nix-instantiate --eval -A notesnook-sync-server.version | jq -e -r)

if [[ $version == "v$old_version" ]]; then
    echo "New version same as old version, nothing to do." >&2
    exit 0
fi

update-source-version notesnook-sync-server "$version"

$(nix-build -A notesnook-sync-server.fetch-deps --no-out-link) "$(dirname -- "${BASH_SOURCE[0]}")/deps.nix"

