#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk jq nix-prefetch-scripts

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/mullvad/mullvadvpn-app/releases/download/${VER}/MullvadVPN-${VER}_${ARCH}.deb"
  nix-prefetch-url --type sha256 "$URL" | xargs nix-hash --type sha256 --to-sri
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

MULLVAD_VER=$(curl -s https://api.mullvad.net/app/v1/releases/linux/2022.5 | jq -r '.latest_stable')

MULLVAD_LINUX_X64_SHA256=$(fetch_arch "$MULLVAD_VER" "amd64")
MULLVAD_LINUX_AARCH64_SHA256=$(fetch_arch "$MULLVAD_VER" "arm64")

sed -i "s/version = \".*\"/version = \"$MULLVAD_VER\"/" "$NIX_DRV"

replace_sha "x86_64-linux" "$MULLVAD_LINUX_X64_SHA256"
replace_sha "aarch64-linux" "$MULLVAD_LINUX_AARCH64_SHA256"
