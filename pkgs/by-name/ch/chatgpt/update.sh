#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gzip jq libxml2
# shellcheck shell=bash

set -o errexit
set -o nounset
set -o pipefail

BASE_URL="https://persistent.oaistatic.com/codex-app-prod"
DARWIN_APPCAST_URL="$BASE_URL/appcast.xml"
LINUX_REPOSITORY_URL="$BASE_URL/linux/deb"

SOURCE_JSON=${SOURCE_JSON:-"$(dirname "${BASH_SOURCE[0]}")/source.json"}

get_field() {
  local field="$1"
  local metadata="$2"

  sed -n "s/^$field: //p" <<< "$metadata" | head -n 1
}

fetch_linux_metadata() {
  local architecture="$1"

  curl --fail --location --silent --show-error \
    "$LINUX_REPOSITORY_URL/dists/stable/main/binary-$architecture/Packages.gz" \
    | gzip --decompress --stdout
}

DARWIN_XML=$(curl --fail --location --silent --show-error "$DARWIN_APPCAST_URL")
DARWIN_VERSION=$(xmllint --xpath '/rss/channel/item[1]/*[local-name()="shortVersionString"]/text()' - <<< "$DARWIN_XML")
DARWIN_URL=$(xmllint --xpath 'string(//item[1]/enclosure/@url)' - <<< "$DARWIN_XML")

for pair in \
  "x86_64-linux amd64" \
  "aarch64-linux arm64"; do
  read -r system architecture <<< "$pair"
  metadata=$(fetch_linux_metadata "$architecture")

  [[ $(get_field Package "$metadata") == chatgpt ]]
  [[ $(get_field Architecture "$metadata") == "$architecture" ]]

  version=$(get_field Version "$metadata")
  filename=$(get_field Filename "$metadata")

  if [[ "$system" == x86_64-linux ]]; then
    AMD64_VERSION=$version
    AMD64_URL="$LINUX_REPOSITORY_URL/$filename"
  else
    ARM64_VERSION=$version
    ARM64_URL="$LINUX_REPOSITORY_URL/$filename"
  fi
done

if [[ -f "$SOURCE_JSON" ]] && jq -e \
  --arg darwin_version "$DARWIN_VERSION" \
  --arg darwin_url "$DARWIN_URL" \
  --arg amd64_version "$AMD64_VERSION" \
  --arg amd64_url "$AMD64_URL" \
  --arg arm64_version "$ARM64_VERSION" \
  --arg arm64_url "$ARM64_URL" \
  '.["aarch64-darwin"].version == $darwin_version
    and .["aarch64-darwin"].src.url == $darwin_url
    and .["x86_64-linux"].version == $amd64_version
    and .["x86_64-linux"].src.url == $amd64_url
    and .["aarch64-linux"].version == $arm64_version
    and .["aarch64-linux"].src.url == $arm64_url' \
  "$SOURCE_JSON" >/dev/null; then
  echo "chatgpt is already up to date" >&2
  exit 0
fi

DARWIN_HASH=$(nix --extra-experimental-features nix-command hash convert \
  --hash-algo sha256 "$(nix-prefetch-url "$DARWIN_URL")")
AMD64_HASH=$(nix --extra-experimental-features nix-command hash convert \
  --hash-algo sha256 "$(nix-prefetch-url "$AMD64_URL")")
ARM64_HASH=$(nix --extra-experimental-features nix-command hash convert \
  --hash-algo sha256 "$(nix-prefetch-url "$ARM64_URL")")

jq -n \
  --arg darwin_version "$DARWIN_VERSION" \
  --arg darwin_url "$DARWIN_URL" \
  --arg darwin_hash "$DARWIN_HASH" \
  --arg amd64_version "$AMD64_VERSION" \
  --arg amd64_url "$AMD64_URL" \
  --arg amd64_hash "$AMD64_HASH" \
  --arg arm64_version "$ARM64_VERSION" \
  --arg arm64_url "$ARM64_URL" \
  --arg arm64_hash "$ARM64_HASH" \
  '{
    "aarch64-darwin": {
      "version": $darwin_version,
      "src": { "url": $darwin_url, "hash": $darwin_hash }
    },
    "aarch64-linux": {
      "version": $arm64_version,
      "src": { "url": $arm64_url, "hash": $arm64_hash }
    },
    "x86_64-linux": {
      "version": $amd64_version,
      "src": { "url": $amd64_url, "hash": $amd64_hash }
    }
  }' > "$SOURCE_JSON"
