#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch
# shellcheck shell=bash

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/desktop.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find desktop.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; SUFFIX="$2"
  URL="https://github.com/vmware-tanzu/octant/releases/download/v${VER}/Octant-${VER}.${SUFFIX}"
  nix-prefetch "{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = \"octant-desktop\"; version = \"${VER}\";
  src = fetchurl { url = \"$URL\"; };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

OCTANT_VER=$(curl -Ls -w "%{url_effective}" -o /dev/null https://github.com/vmware-tanzu/octant/releases/latest | awk -F'/' '{print $NF}' | sed 's/v//')

OCTANT_DESKTOP_LINUX_X64_SHA256=$(fetch_arch "$OCTANT_VER" "AppImage")
OCTANT_DESKTOP_DARWIN_X64_SHA256=$(fetch_arch "$OCTANT_VER" "dmg")

sed -i "s/version = \".*\"/version = \"$OCTANT_VER\"/" "$NIX_DRV"

replace_sha "x86_64-linux" "$OCTANT_DESKTOP_LINUX_X64_SHA256"
replace_sha "x86_64-darwin" "$OCTANT_DESKTOP_DARWIN_X64_SHA256"
