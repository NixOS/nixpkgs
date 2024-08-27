#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/openbao/openbao/releases/download/v${VER}/bao_${VER}_${ARCH}.tar.gz"
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"openbao-bin\"; version = \"${VER}\";
  src = fetchzip {
    url = \"$URL\";
    stripRoot = false;
  };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

# https://github.com/openbao/openbao/v2.0.0/bao_2.0.0_linux_arm64.tar.gz
BAO_VER=$(curl -Ls -w "%{url_effective}" -o /dev/null https://github.com/openbao/openbao/releases/latest | awk -F'/' '{print $NF}' | sed 's/v//')

echo "latest version: $BAO_VER"

BAO_LINUX_AARCH64_SHA256=$(fetch_arch "$BAO_VER" "Linux_arm64")
BAO_LINUX_X64_SHA256=$(fetch_arch "$BAO_VER" "Linux_x86_64")
BAO_DARWIN_X64_SHA256=$(fetch_arch "$BAO_VER" "Darwin_x86_64")
BAO_DARWIN_AARCH64_SHA256=$(fetch_arch "$BAO_VER" "Darwin_arm64")

sed -i "s/version = \".*\"/version = \"$BAO_VER\"/" "$NIX_DRV"

replace_sha "x86_64-linux" "$BAO_LINUX_X64_SHA256"
replace_sha "x86_64-darwin" "$BAO_DARWIN_X64_SHA256"
replace_sha "aarch64-linux" "$BAO_LINUX_AARCH64_SHA256"
replace_sha "aarch64-darwin" "$BAO_DARWIN_AARCH64_SHA256"
