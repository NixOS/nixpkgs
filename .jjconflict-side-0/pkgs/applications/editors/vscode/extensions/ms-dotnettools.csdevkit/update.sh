#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix common-updater-scripts
# shellcheck shell=bash
set -euo pipefail

export LC_ALL=C

PUBLISHER=ms-dotnettools
EXTENSION=csdevkit

response=$(curl -s 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
    -H 'accept: application/json;api-version=3.0-preview.1' \
    -H 'content-type: application/json' \
    --data-raw '{"filters":[{"criteria":[{"filterType":7,"value":"'"$PUBLISHER.$EXTENSION"'"}]}],"flags":16}')

# Find the latest version compatible with stable vscode version
latest_version=$(jq --raw-output '
.results[0].extensions[0].versions
| map(select(has("properties")))
| map(select(.properties | map(select(.key == "Microsoft.VisualStudio.Code.Engine")) | .[0].value | test("\\^[0-9.]+$")))
| map(select(.properties | map(select(.key == "Microsoft.VisualStudio.Code.PreRelease")) | .[0].value != "true"))
| .[0].version' <<<"$response")

getDownloadUrl() {
    nix-instantiate \
        --eval \
        --strict \
        --json \
        'pkgs/applications/editors/vscode/extensions/mktplcExtRefToFetchArgs.nix' \
        --attr url \
        --argstr publisher $PUBLISHER \
        --argstr name $EXTENSION \
        --argstr version "$latest_version" \
        --argstr arch "$1" | jq . --raw-output
}

update_hash() {
    local hash
    hash=$(nix hash convert --hash-algo sha256 "$(nix-prefetch-url --type sha256 "$(getDownloadUrl "$2")")")
    update-source-version vscode-extensions.$PUBLISHER.$EXTENSION "$latest_version" "$hash" --system="$1" --ignore-same-version
}

update_hash x86_64-linux linux-x64
update_hash aarch64-linux linux-arm64
update_hash x86_64-darwin darwin-x64
update_hash aarch64-darwin darwin-arm64
