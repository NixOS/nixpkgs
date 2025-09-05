#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk jq nix-prefetch

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/expo/orbit/releases/download/expo-orbit-v${VER}/expo-orbit_${VER}_${ARCH}.deb"
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"expo-orbit\"; version = \"${VER}\";
  src = fetchurl { url = \"$URL\"; };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

EXPO_VER=$(curl -s https://api.github.com/repos/expo/orbit/releases/latest | jq -r '.tag_name | ltrimstr("expo-orbit-v")')

EXPO_LINUX_X64_SHA256=$(fetch_arch "$EXPO_VER" "amd64")

sed -i "s/version = \".*\"/version = \"$EXPO_VER\"/" "$NIX_DRV"

replace_sha "x86_64-linux" "$EXPO_LINUX_X64_SHA256"
