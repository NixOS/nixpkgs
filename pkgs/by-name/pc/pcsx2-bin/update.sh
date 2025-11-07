#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

cd "$(dirname "$0")" || exit 1

# Grab latest version, ignoring "latest" and "preview" tags
LATEST_VER="$(curl --fail -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/PCSX2/pcsx2/releases/latest" | jq -r '.tag_name' | sed 's/^v//')"
CURRENT_VER="$(grep -oP 'version = "\K[^"]+' package.nix)"

if [[ "$LATEST_VER" == "$CURRENT_VER" ]]; then
    echo "pcsx2-bin is up-to-date"
    exit 0
fi

HASH="$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "https://github.com/PCSX2/pcsx2/releases/download/v${LATEST_VER}/pcsx2-v${LATEST_VER}-macos-Qt.tar.xz")")"

sed -i "s#hash = \".*\"#hash = \"$HASH\"#g" package.nix
sed -i "s#version = \".*\";#version = \"$LATEST_VER\";#g" package.nix
