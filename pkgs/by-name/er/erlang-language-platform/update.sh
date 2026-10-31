#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

SCRIPT_DIR="$(readlink -f "$(dirname "$0")")"
PACKAGE_FILE="$SCRIPT_DIR/package.nix"
HASHES_FILE="$SCRIPT_DIR/hashes.json"

curl_github() {
    curl -L ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

release_json=$(curl_github https://api.github.com/repos/WhatsApp/erlang-language-platform/releases/latest)
version=$(echo "$release_json" | jq -r '.tag_name')
releases=$(echo "$release_json" | jq -r '.assets[] | select(.browser_download_url | test(".tar.gz$")) | .name + ":" + .browser_download_url')

# update version to latest
sed -i -E "s/^(.*)\bversion = \".*\"/\1version = \"$version\"/" "$PACKAGE_FILE"

for release in $releases; do
  IFS=: read -r name url <<< "$release"
  hash_name=$(echo "$name" | sed 's/.tar.gz$//')
  hash_prefetched=$(nix-prefetch-url --type sha256 "$url")
  hash_sri=$(nix hash to-sri --type sha256 "$hash_prefetched")
  echo "$hash_name" "$hash_sri"
done |
  jq -sR 'rtrimstr("\n") | split("\n") | map(split(" ") | {(.[0]): .[1]}) | add' > "$HASHES_FILE"
