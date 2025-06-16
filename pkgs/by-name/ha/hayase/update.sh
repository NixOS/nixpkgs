#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [[ ! "$(basename $ROOT)" == "hayase" || ! -f "$ROOT/package.nix" ]]; then
    echo "error: Not in the hayase folder" >&2
    exit 1
fi

PACKAGE_NIX="$ROOT/package.nix"
LINUX_NIX="$ROOT/linux.nix"
DARWIN_NIX="$ROOT/darwin.nix"

HAYASE_LATEST_VER="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/ThaUnknown/miru/releases/latest" | jq -r .tag_name | sed 's/^v//')"
HAYASE_CURRENT_VER="$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX")"

if [[ "$HAYASE_LATEST_VER" == "null" ]]; then
    echo "error: could not fetch hayase latest version from GitHub API" >&2
    exit 1
fi

if [[ "$HAYASE_LATEST_VER" == "$HAYASE_CURRENT_VER" ]]; then
    echo "hayase is up-to-date"
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

HAYASE_LINUX_HASH="$(get_hash "https://github.com/ThaUnknown/miru/releases/download/v${HAYASE_LATEST_VER}/linux-hayase-${HAYASE_LATEST_VER}-linux.AppImage")"
HAYASE_DARWIN_HASH="$(get_hash "https://github.com/ThaUnknown/miru/releases/download/v${HAYASE_LATEST_VER}/mac-hayase-${HAYASE_LATEST_VER}-mac.dmg")"

replace_hash_in_file "$LINUX_NIX" "$HAYASE_LINUX_HASH"
replace_hash_in_file "$DARWIN_NIX" "$HAYASE_DARWIN_HASH"

replace_version_in_file "$PACKAGE_NIX" "$HAYASE_LATEST_VER"
