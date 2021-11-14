#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch
# shellcheck shell=bash

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/default.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/vmware-tanzu/octant/releases/download/v${VER}/octant_${VER}_${ARCH}.tar.gz"
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"octant\"; version = \"${VER}\";
  src = fetchzip { url = \"$URL\"; };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

OCTANT_VER=$(curl -Ls -w "%{url_effective}" -o /dev/null https://github.com/vmware-tanzu/octant/releases/latest | awk -F'/' '{print $NF}' | sed 's/v//')

OCTANT_LINUX_X64_SHA256=$(fetch_arch "$OCTANT_VER" "Linux-64bit")
OCTANT_LINUX_AARCH64_SHA256=$(fetch_arch "$OCTANT_VER" "Linux-arm64")
OCTANT_DARWIN_X64_SHA256=$(fetch_arch "$OCTANT_VER" "macOS-64bit")
OCTANT_DARWIN_AARCH64_SHA256=$(fetch_arch "$OCTANT_VER" "macOS-arm64")

sed -i "s/version = \".*\"/version = \"$OCTANT_VER\"/" "$NIX_DRV"

replace_sha "x86_64-linux" "$OCTANT_LINUX_X64_SHA256"
replace_sha "aarch64-linux" "$OCTANT_LINUX_AARCH64_SHA256"
replace_sha "x86_64-darwin" "$OCTANT_DARWIN_X64_SHA256"
replace_sha "aarch64-darwin" "$OCTANT_DARWIN_AARCH64_SHA256"
