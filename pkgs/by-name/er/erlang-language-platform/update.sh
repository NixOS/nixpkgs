#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

curl_github() {
    curl -L ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

release_json=$(curl_github https://api.github.com/repos/WhatsApp/erlang-language-platform/releases/latest)
version=$(echo "$release_json" | jq -r '.tag_name')
releases=$(echo "$release_json" | jq -r '.assets[] | select(.browser_download_url | test(".tar.gz$")) | .name + ":" + .browser_download_url')

update-source-version erlang-language-platform "$version" --file=./pkgs/by-name/er/erlang-language-platform/package.nix

for release in $releases; do
  IFS=: read -r name url <<< "$release"
  hash_name=$(echo "$name" | sed 's/.tar.gz$//')
  hash_prefetched=$(nix-prefetch-url --type sha256 "$url")
  hash_sri=$(nix hash to-sri --type sha256 "$hash_prefetched")
  echo "$hash_name" "$hash_sri"
done |
  jq -sR 'rtrimstr("\n") | split("\n") | map(split(" ") | {(.[0]): .[1]}) | add' > hashes.json
