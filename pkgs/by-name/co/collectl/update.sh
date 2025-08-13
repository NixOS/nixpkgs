#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [[ ! "$(basename $ROOT)" == "collectl" || ! -f "$ROOT/package.nix" ]]; then
  echo "error: Not in the collectl folder" >&2
  exit 1
fi

PACKAGE_NIX="$ROOT/package.nix"
LINUX_NIX="$ROOT/linux.nix"

# Get latest version from SourceForge RSS feed
COLLECTL_LATEST_VER="$(curl -s "https://sourceforge.net/projects/collectl/rss?path=/" | grep -oP 'collectl-\K[0-9]+\.[0-9]+\.[0-9]+(?=\.src\.tar\.gz)' | sort -V | tail -n1)"
COLLECTL_CURRENT_VER="$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX")"

if [[ "$COLLECTL_LATEST_VER" == "" ]]; then
  echo "error: could not fetch collectl latest version from SourceForge RSS" >&2
  exit 1
fi

if [[ "$COLLECTL_LATEST_VER" == "$COLLECTL_CURRENT_VER" ]]; then
  echo "collectl is up-to-date"
  exit 0
fi

get_hash() {
  # $1: URL
  nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$1")"
}

replace_hash_in_file() {
  # $1: file
  # $2: new hash
  sed -i "s#sha256 = \".*\"#sha256 = \"$2\"#g" "$1"
}

replace_version_in_file() {
  # $1: file
  # $2: new version
  sed -i "s#version = \".*\";#version = \"$2\";#g" "$1"
}

COLLECTL_HASH="$(get_hash "https://sourceforge.net/projects/collectl/files/collectl-${COLLECTL_LATEST_VER}.src.tar.gz/download")"

replace_hash_in_file "$LINUX_NIX" "$COLLECTL_HASH"
replace_version_in_file "$PACKAGE_NIX" "$COLLECTL_LATEST_VER"

echo "Updated collectl from $COLLECTL_CURRENT_VER to $COLLECTL_LATEST_VER"
