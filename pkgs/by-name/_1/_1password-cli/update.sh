#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nurl xq-xml

set -eu

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

fetch_linux() {
  VER="$1"
  ARCH="$2"
  URL="https://cache.agilebits.com/dist/1P/op2/pkg/v${VER}/op_${ARCH}_v${VER}.zip"
  nurl --hash --expr "(import <nixpkgs> { }).fetchzip { url = \"$URL\"; stripRoot = false; }"
}

fetch_darwin() {
  VER="$1"
  URL="https://cache.agilebits.com/dist/1P/op2/pkg/v${VER}/op_apple_universal_v${VER}.pkg"
  nurl --hash --expr "(import <nixpkgs> { }).fetchurl { url = \"$URL\"; }"
}

replace_sha() {
  sed -i "s|\"$1\" \"sha256-.\{44\}\"|\"$1\" \"$2\"|" "$NIX_DRV"
}

CLI_VERSION="$(curl -Ls https://app-updates.agilebits.com/product_history/CLI2 | xq -q 'h3' | head -n1)"

CLI_LINUX_AARCH64_SHA256=$(fetch_linux "$CLI_VERSION" "linux_arm64")
CLI_LINUX_I686_SHA256=$(fetch_linux "$CLI_VERSION" "linux_386")
CLI_LINUX_X64_SHA256=$(fetch_linux "$CLI_VERSION" "linux_amd64")
CLI_DARWIN_UNIVERSAL_SHA256=$(fetch_darwin "$CLI_VERSION")

sed -i "s/version = \".*\"/version = \"$CLI_VERSION\"/" "$NIX_DRV"

replace_sha "linux_arm64" "$CLI_LINUX_AARCH64_SHA256"
replace_sha "linux_386" "$CLI_LINUX_I686_SHA256"
replace_sha "linux_amd64" "$CLI_LINUX_X64_SHA256"
replace_sha "apple_universal" "$CLI_DARWIN_UNIVERSAL_SHA256"
