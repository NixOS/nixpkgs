#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [[ ! "$(basename $ROOT)" == "miru" || ! -f "$ROOT/package.nix" ]]; then
    echo "error: Not in the miru folder" >&2
    exit 1
fi

PACKAGE_NIX="$ROOT/package.nix"
LINUX_NIX="$ROOT/linux.nix"
DARWIN_NIX="$ROOT/darwin.nix"

MIRU_LATEST_VER="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/ThaUnknown/miru/releases/latest" | jq -r .tag_name | sed 's/^v//')"
MIRU_CURRENT_VER="$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX")"

if [[ "$MIRU_LATEST_VER" == "null" ]]; then
    echo "error: could not fetch miru latest version from GitHub API" >&2
    exit 1
fi

if [[ "$MIRU_LATEST_VER" == "$MIRU_CURRENT_VER" ]]; then
    echo "miru is up-to-date"
    exit 0
fi

get_hash() {
    # $1: URL
    nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$1")"
}

replace_hash_in_file() {
    # $1: file
    # $2: new hash
    sed -i "s#hash = \".*\"#hash = \"$2\"#g" "$1"
}

replace_version_in_file() {
    # $1: file
    # $2: new version
    sed -i "s#version = \".*\";#version = \"$2\";#g" "$1"
}

MIRU_LINUX_HASH="$(get_hash "https://github.com/ThaUnknown/miru/releases/download/v${MIRU_LATEST_VER}/linux-Miru-${MIRU_LATEST_VER}.AppImage")"
MIRU_DARWIN_HASH="$(get_hash "https://github.com/ThaUnknown/miru/releases/download/v${MIRU_LATEST_VER}/mac-Miru-${MIRU_LATEST_VER}-mac.zip")"

replace_hash_in_file "$LINUX_NIX" "$MIRU_LINUX_HASH"
replace_hash_in_file "$DARWIN_NIX" "$MIRU_DARWIN_HASH"

replace_version_in_file "$PACKAGE_NIX" "$MIRU_LATEST_VER"
