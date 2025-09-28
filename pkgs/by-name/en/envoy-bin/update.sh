#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils gnused ripgrep

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"
  ARCH="$2"
  URL="https://github.com/envoyproxy/envoy/releases/download/v${VER}/envoy-${VER}-linux-${ARCH}"
  nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --type sha256 "$URL")"
}

replace_hash() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

VER=$(list-git-tags --url=https://github.com/envoyproxy/envoy | rg 'v[0-9\.]*$' | sed -e 's/^v//' | sort -V | tail -n 1)

LINUX_X64_HASH=$(fetch_arch "$VER" "x86_64")
LINUX_AARCH64_HASH=$(fetch_arch "$VER" "aarch_64")

sed -i "s/version = \".*\"/version = \"$VER\"/" "$NIX_DRV"

replace_hash "x86_64-linux" "$LINUX_X64_HASH"
replace_hash "aarch64-linux" "$LINUX_AARCH64_HASH"
