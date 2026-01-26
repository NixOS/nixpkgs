#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils nix _7zz
# shellcheck shell=bash
set -euo pipefail

cd -- "$(dirname "${BASH_SOURCE[0]}")"

META=$(curl -fsSL "https://api2.cursor.sh/updates/api/download/stable/linux-x64/cursor")
VERSION=$(jq -r '.version' <<< "$META")
CURRENT=$(jq -r '.version' sources.json)

[[ "$VERSION" == "$CURRENT" ]] && { echo "Already up to date ($VERSION)"; exit 0; }

SOURCES="{}"
VSCODE=""

for pair in \
  x86_64-linux:linux-x64 \
  aarch64-linux:linux-arm64 \
  x86_64-darwin:darwin-x64 \
  aarch64-darwin:darwin-arm64
do
  IFS=: read -r sys platform <<< "$pair"
  meta=$(curl -fsSL "https://api2.cursor.sh/updates/api/download/stable/$platform/cursor")
  version=$(jq -r '.version' <<< "$meta")

  [[ "$version" != "$VERSION" ]] && { echo "Version mismatch: $sys has $version, expected $VERSION"; exit 1; }

  url=$(jq -r '.downloadUrl' <<< "$meta")

  { read -r hash; read -r path; } < <(nix-prefetch-url --print-path "$url")

  sri=$(nix-hash --type sha256 --to-sri "$hash")

  if [[ "$sys" == "x86_64-linux" ]]; then
    VSCODE=$(7zz x -so "$path" "usr/share/cursor/resources/app/product.json" 2>/dev/null | jq -r '.vscodeVersion')
  fi

  SOURCES=$(jq -n --argjson src "$SOURCES" --arg sys "$sys" --arg url "$url" --arg hash "$sri" \
    '$src + {($sys): {url: $url, hash: $hash}}')
done

jq -n --arg v "$VERSION" --arg vs "$VSCODE" --argjson s "$SOURCES" \
  '{version: $v, vscodeVersion: $vs, sources: $s}' > sources.json
