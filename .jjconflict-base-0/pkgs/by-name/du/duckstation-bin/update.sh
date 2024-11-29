#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

cd "$(dirname "$0")" || exit 1

# Grab latest version, ignoring "latest" and "preview" tags
LATEST_VER="$(curl --fail -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/stenzek/duckstation/releases" | jq -r '.[].tag_name' | grep '^v' | head -n 1 | sed 's/^v//')"
CURRENT_VER="$(grep -oP 'version = "\K[^"]+' package.nix)"

if [[ "$LATEST_VER" == "$CURRENT_VER" ]]; then
    echo "duckstation-bin is up-to-date"
    exit 0
fi

HASH="$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "https://github.com/stenzek/duckstation/releases/download/v${LATEST_VER}/duckstation-mac-release.zip")")"

sed -i "s#hash = \".*\"#hash = \"$HASH\"#g" package.nix
sed -i "s#version = \".*\";#version = \"$LATEST_VER\";#g" package.nix
