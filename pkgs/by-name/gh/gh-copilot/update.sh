#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nix-prefetch

set -euo pipefail
set -x

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find gh-copilot in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/github/gh-copilot/releases/download/v${VER}/${ARCH}";
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"vere\"; version = \"${VER}\";
  src = fetchurl { url = \"$URL\"; };
}
"
}

replace_sha() {
  # https://stackoverflow.com/a/38470458/22235705
  sed -rziE "s@($1[^\n]*\n[^\n]*hash = )\"sha256-.{44}\";@\1\"$2\";@" "$NIX_DRV"
}

VERE_VER=$(curl https://api.github.com/repos/github/gh-copilot/releases/latest | jq .tag_name)
VERE_VER=$(echo $VERE_VER | sed -e 's/^"v//' -e 's/"$//') # transform "v1.0.2" into 1.0.2

VERE_LINUX_X64_SHA256=$(fetch_arch "$VERE_VER" "linux-amd64")
VERE_LINUX_AARCH64_SHA256=$(fetch_arch "$VERE_VER" "linux-arm64")
VERE_DARWIN_X64_SHA256=$(fetch_arch "$VERE_VER" "darwin-amd64")
VERE_DARWIN_AARCH64_SHA256=$(fetch_arch "$VERE_VER" "darwin-arm64")

sed -i "s/version = \".*\"/version = \"$VERE_VER\"/" "$NIX_DRV"

replace_sha "linux-amd64" "$VERE_LINUX_X64_SHA256"
replace_sha "linux-arm64" "$VERE_LINUX_AARCH64_SHA256"
replace_sha "darwin-amd64" "$VERE_DARWIN_X64_SHA256"
replace_sha "darwin-arm64" "$VERE_DARWIN_AARCH64_SHA256"
