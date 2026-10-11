#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils nix ripgrep
# shellcheck shell=bash
set -euo pipefail

cd -- "$(dirname "${BASH_SOURCE[0]}")"

INDEX_URL="https://www.siliconmotion.com/downloads/index.html"
LINUX_NOTES_URL="https://www.siliconmotion.com/downloads/Release%20Notes/SiliconMotion%20USB%20Graphics%20Software%20for%20Ubuntu%20release%20note.txt"
UA="nixpkgs#instantview update.sh"

CURL=(curl --fail --silent --show-error --proto "=https" --tlsv1.2 -H "User-Agent: ${UA}")

html=$("${CURL[@]}" "$INDEX_URL")
notes=$("${CURL[@]}" "$LINUX_NOTES_URL")

# Authoritative version from release notes head, e.g. "InstantView release  V2.24.8.0"
linux_ver=$(rg -o 'InstantView release\s+V([0-9]+(?:\.[0-9]+)+)' -r '$1' <<<"$notes" | head -n1)
if [[ -z $linux_ver ]]; then
  echo "update.sh: failed to parse InstantView version from Linux release notes" >&2
  exit 1
fi

# Artifact URL from downloads index (first Linux zip)
linux_url=$(rg -o 'https://www\.siliconmotion\.com/downloads/SMI-USB-Display-for-Linux-v[^"[:space:]]+\.zip' <<<"$html" | head -n1)
if [[ -z $linux_url ]]; then
  linux_url=$(rg -o 'SMI-USB-Display-for-Linux-v[^"[:space:]]+\.zip' <<<"$html" | head -n1)
  if [[ -n $linux_url ]]; then
    linux_url="https://www.siliconmotion.com/downloads/${linux_url}"
  fi
fi
if [[ -z $linux_url ]]; then
  linux_url="https://www.siliconmotion.com/downloads/SMI-USB-Display-for-Linux-v${linux_ver}.zip"
fi

url_ver=$(rg -o 'SMI-USB-Display-for-Linux-v([0-9.]+)\.zip' -r '$1' <<<"$linux_url" || true)
if [[ -n $url_ver && $url_ver != "$linux_ver" ]]; then
  echo "update.sh: version mismatch: notes=${linux_ver} url=${url_ver}" >&2
  exit 1
fi

"${CURL[@]}" -I -o /dev/null "$linux_url"

current=$(jq -r .version sources.json)
attrPath="${UPDATE_NIX_ATTR_PATH:-instantview}"

if [[ $linux_ver == "$current" ]]; then
  echo "Already up to date (linux=${linux_ver})" >&2
  echo '[]'
  exit 0
fi

echo "Updating ${attrPath}: ${current} -> ${linux_ver}" >&2
echo "Prefetching ${linux_url}" >&2

{
  read -r hash
  read -r _path
} < <(nix-prefetch-url --print-path "$linux_url")
sri=$(nix hash to-sri --type sha256 "$hash" 2>/dev/null || nix-hash --type sha256 --to-sri "$hash")

jq -n \
  --arg v "$linux_ver" \
  --arg u "$linux_url" \
  --arg h "$sri" \
  --arg n "$LINUX_NOTES_URL" \
  '{ version: $v, url: $u, hash: $h, releaseNotes: $n }' >sources.json

pkgDir=$(pwd)
echo "[{\"attrPath\":\"${attrPath}\",\"oldVersion\":\"${current}\",\"newVersion\":\"${linux_ver}\",\"files\":[\"${pkgDir}/sources.json\"],\"commitBody\":\"Release notes: ${LINUX_NOTES_URL}\"}]"
