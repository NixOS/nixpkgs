#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

cd "$(dirname "$0")" || exit 1

# Grab latest version from the GitHub repository
LATEST_VER="$(curl --fail -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/4ian/GDevelop/releases" | jq -r '.[0].tag_name' | sed 's/^v//')"
CURRENT_VER="$(grep -oP 'version = "\K[^"]+' package.nix)"

if [[ "$LATEST_VER" == "$CURRENT_VER" ]]; then
    echo "gdevelop is up-to-date"
    exit 0
fi

echo "Updating gdevelop from $CURRENT_VER to $LATEST_VER"

# Update the version
sed -i "s#version = \".*\";#version = \"$LATEST_VER\";#g" package.nix

# Update hashes
# - Linux

LINUX_HASH="$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "https://github.com/4ian/GDevelop/releases/download/v${LATEST_VER}/GDevelop-5-${LATEST_VER}.AppImage")")"
sed -i "s#hash = \".*\"#hash = \"$LINUX_HASH\"#g" linux.nix

# - Darwin

DARWIN_HASH="$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "https://github.com/4ian/GDevelop/releases/download/v${LATEST_VER}/GDevelop-5-${LATEST_VER}-universal-mac.zip")")"
sed -i "s#hash = \".*\"#hash = \"$DARWIN_HASH\"#g" darwin.nix

echo "Updated gdevelop to $LATEST_VER"
