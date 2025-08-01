#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch jq

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/Exafunction/codeium/releases/download/language-server-v${VER}/language_server_${ARCH}.gz"
  nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$URL")"
}

replace_hash() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

CODEIUM_VER=$(curl -s "https://api.github.com/repos/Exafunction/codeium/releases/latest" | jq -r .tag_name | grep -oP '\d+\.\d+\.\d+' )

CODEIUM_LINUX_X64_HASH=$(fetch_arch "$CODEIUM_VER" "linux_x64")
CODEIUM_LINUX_AARCH64_HASH=$(fetch_arch "$CODEIUM_VER" "linux_arm")
CODEIUM_DARWIN_X64_HASH=$(fetch_arch "$CODEIUM_VER" "macos_x64")
CODEIUM_DARWIN_AARCH64_HASH=$(fetch_arch "$CODEIUM_VER" "macos_arm")

sed -i "s/version = \".*\"/version = \"$CODEIUM_VER\"/" "$NIX_DRV"

replace_hash "x86_64-linux" "$CODEIUM_LINUX_X64_HASH"
replace_hash "aarch64-linux" "$CODEIUM_LINUX_AARCH64_HASH"
replace_hash "x86_64-darwin" "$CODEIUM_DARWIN_X64_HASH"
replace_hash "aarch64-darwin" "$CODEIUM_DARWIN_AARCH64_HASH"
