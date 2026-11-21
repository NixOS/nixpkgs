#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gnugrep nix

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

calc_hash() {
  local platform=$1 version=$2
  local url="https://ssd.mathworks.com/supportfiles/downloads/mpm/${version}/${platform}/mpm"
  local file_hash
  file_hash=$(nix-prefetch-url "$url")
  nix --extra-experimental-features nix-command hash to-sri --type sha256 "$file_hash"
}

replace_hash() {
  local platform=$1 hash=$2
  sed -i "/mathworks_platform = \"$platform\";/{n;s#hash = \"sha256-.*\"#hash = \"$hash\"#}" "$NIX_DRV"
}

MPM_VER=$(curl -sI https://www.mathworks.com/mpm/glnxa64/mpm \
  | grep -i '^location:' | grep -oP '/mpm/\K[0-9]{4}\.[0-9]+')

MACA64_HASH=$(calc_hash "maca64" "$MPM_VER")
GLNXA64_HASH=$(calc_hash "glnxa64" "$MPM_VER")

sed -i "s/version = \".*\"/version = \"$MPM_VER\"/" "$NIX_DRV"

replace_hash "maca64" "$MACA64_HASH"
replace_hash "glnxa64" "$GLNXA64_HASH"
