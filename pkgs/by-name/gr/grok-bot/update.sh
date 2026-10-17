#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils nix
# shellcheck shell=bash
set -euo pipefail

cd -- "$(dirname "${BASH_SOURCE[0]}")"

META=$(curl -fsSL "https://api2.cursor.sh/updates/api/download/stable/linux-x64/sand")
VERSION=$(jq -r '.version' <<< "$META")
COMMIT=$(jq -r '.commitSha' <<< "$META")
CURRENT=$(jq -r '.version' sources.json)

[[ "$VERSION" == "$CURRENT" ]] && { echo "Already up to date ($VERSION)"; exit 0; }

SOURCES="{}"

for pair in \
  x86_64-linux:linux-x64 \
  aarch64-linux:linux-arm64
do
  IFS=: read -r sys platform <<< "$pair"
  meta=$(curl -fsSL "https://api2.cursor.sh/updates/api/download/stable/$platform/sand")
  version=$(jq -r '.version' <<< "$meta")
  commit=$(jq -r '.commitSha' <<< "$meta")

  [[ "$version" != "$VERSION" ]] && { echo "Version mismatch: $sys has $version, expected $VERSION"; exit 1; }
  [[ "$commit" != "$COMMIT" ]] && { echo "Commit mismatch: $sys has $commit, expected $COMMIT"; exit 1; }

  url=$(jq -r '.debUrl' <<< "$meta")

  { read -r hash; read -r _path; } < <(nix-prefetch-url --print-path "$url")

  sri=$(nix-hash --type sha256 --to-sri "$hash")

  SOURCES=$(jq -n --argjson src "$SOURCES" --arg sys "$sys" --arg url "$url" --arg hash "$sri" \
    '$src + {($sys): {url: $url, hash: $hash}}')
done

jq -n --arg v "$VERSION" --arg c "$COMMIT" --argjson s "$SOURCES" \
  '{version: $v, commitSha: $c, sources: $s}' > sources.json

echo "Updated sources.json to $VERSION ($COMMIT)"
