#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

cd "$(dirname "$0")" || exit 1

# Grab latest release version
LOOPWM_LATEST_VER="$(curl --fail -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/MrKai77/Loop/releases/latest" | jq -r '.tag_name' | sed 's/^v//')"
LOOPWM_CURRENT_VER="$(grep -oP 'version = "\K[^"]+' package.nix)"

if [[ "$LOOPWM_LATEST_VER" == "$LOOPWM_CURRENT_VER" ]]; then
    echo "loopwm is up-to-date"
    exit 0
fi

LOOPWM_DARWIN_HASH="$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "https://github.com/MrKai77/Loop/releases/download/${LOOPWM_LATEST_VER}/Loop.zip")")"

sed -i "s#hash = \".*\"#hash = \"$LOOPWM_DARWIN_HASH\"#g" package.nix
sed -i "s#version = \".*\";#version = \"$LOOPWM_LATEST_VER\";#g" package.nix
