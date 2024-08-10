#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [[ ! "$(basename "$ROOT")" == "pcsx2-bin" || ! -f "$ROOT/package.nix" ]]; then
    echo "error: Not in the pcsx2-bin folder" >&2
    exit 1
fi

PACKAGE_NIX="$ROOT/package.nix"

# Grab latest (pre)release version
PCSX2_LATEST_VER="$(curl --fail -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/PCSX2/pcsx2/releases" | jq -r '.[0].tag_name' | sed 's/^v//')"
PCSX2_CURRENT_VER="$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX")"

if [[ "$PCSX2_LATEST_VER" == "$PCSX2_CURRENT_VER" ]]; then
    echo "pcsx2-bin is up-to-date"
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

PCSX2_DARWIN_HASH="$(get_hash "https://github.com/PCSX2/pcsx2/releases/download/v${PCSX2_LATEST_VER}/pcsx2-v${PCSX2_LATEST_VER}-macos-Qt.tar.xz")"

replace_hash_in_file "$PACKAGE_NIX" "$PCSX2_DARWIN_HASH"
replace_version_in_file "$PACKAGE_NIX" "$PCSX2_LATEST_VER"
