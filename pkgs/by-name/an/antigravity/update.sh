#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq
# shellcheck shell=bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PACKAGE_NIX="${SCRIPT_DIR}/package.nix"
SOURCES_JSON="${SCRIPT_DIR}/sources.json"
DOWNLOAD_PAGE_URL="https://antigravity.google/download/linux"

# Fetch download page
page=$(curl -fsSL --compressed "$DOWNLOAD_PAGE_URL")
script_name=$(printf '%s\n' "$page" | grep -o 'main-[a-zA-Z0-9]*\.js' | head -n 1)
js_content=$(curl -fsSL --compressed "https://antigravity.google/$script_name")

# Extract Linux x86_64 URL
linux_x86_64_url=$(
  printf '%s\n' "$js_content" \
    | grep -o 'https://[^"]*/linux-x64/Antigravity.tar.gz' \
    | head -n 1
)

# Extract Version
version=$(
  printf '%s\n' "$linux_x86_64_url" \
    | sed -n 's#.*/stable/\([^/]*\)/linux-x64/Antigravity.tar.gz#\1#p'
)

echo "Version: $version"

# Derive URLs
linux_aarch64_url="${linux_x86_64_url/linux-x64\/Antigravity.tar.gz/linux-arm\/Antigravity.tar.gz}"
darwin_x86_64_url="${linux_x86_64_url/linux-x64\/Antigravity.tar.gz/darwin-x64\/Antigravity.zip}"
darwin_aarch64_url="${linux_x86_64_url/linux-x64\/Antigravity.tar.gz/darwin-arm\/Antigravity.zip}"

echo "Prefetching x86_64-linux from $linux_x86_64_url..."
prefetch_output=$(nix-prefetch-url --print-path "$linux_x86_64_url")
linux_x86_64_hash_base32=$(echo "$prefetch_output" | head -n 1)
archive_path=$(echo "$prefetch_output" | tail -n 1)
echo "path is '$archive_path'" >&2
linux_x86_64_hash=$(nix-hash --type sha256 --to-sri "$linux_x86_64_hash_base32")

echo "Prefetching aarch64-linux from $linux_aarch64_url..."
linux_aarch64_hash_base32=$(nix-prefetch-url "$linux_aarch64_url")
linux_aarch64_hash=$(nix-hash --type sha256 --to-sri "$linux_aarch64_hash_base32")

echo "Prefetching x86_64-darwin from $darwin_x86_64_url..."
darwin_x86_64_hash_base32=$(nix-prefetch-url "$darwin_x86_64_url")
darwin_x86_64_hash=$(nix-hash --type sha256 --to-sri "$darwin_x86_64_hash_base32")

echo "Prefetching aarch64-darwin from $darwin_aarch64_url..."
darwin_aarch64_hash_base32=$(nix-prefetch-url "$darwin_aarch64_url")
darwin_aarch64_hash=$(nix-hash --type sha256 --to-sri "$darwin_aarch64_hash_base32")

echo "Extracting VS Code version..."
vscodeVersion=$(
  tar -Oxzf "$archive_path" "Antigravity/resources/app/product.json" \
    | jq -r '.version'
)
echo "VS Code version: $vscodeVersion"

echo "Updating package.nix..."
sed -i "s/version = \".*\"/version = \"$version\"/" "$PACKAGE_NIX"
sed -i "s/vscodeVersion = \".*\"/vscodeVersion = \"$vscodeVersion\"/" "$PACKAGE_NIX"

echo "Updating sources.json..."
jq -n \
  --arg linux_x86_64_url "$linux_x86_64_url" \
  --arg linux_x86_64_hash "$linux_x86_64_hash" \
  --arg linux_aarch64_url "$linux_aarch64_url" \
  --arg linux_aarch64_hash "$linux_aarch64_hash" \
  --arg darwin_x86_64_url "$darwin_x86_64_url" \
  --arg darwin_x86_64_hash "$darwin_x86_64_hash" \
  --arg darwin_aarch64_url "$darwin_aarch64_url" \
  --arg darwin_aarch64_hash "$darwin_aarch64_hash" \
  '{
    "x86_64-linux": { url: $linux_x86_64_url, hash: $linux_x86_64_hash },
    "aarch64-linux": { url: $linux_aarch64_url, hash: $linux_aarch64_hash },
    "x86_64-darwin": { url: $darwin_x86_64_url, hash: $darwin_x86_64_hash },
    "aarch64-darwin": { url: $darwin_aarch64_url, hash: $darwin_aarch64_hash }
  }' > "$SOURCES_JSON"

echo "Update complete."
