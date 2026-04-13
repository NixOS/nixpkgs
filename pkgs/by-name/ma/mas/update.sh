#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nurl gnused

set -eu

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"

VERSION="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/mas-cli/mas/releases/latest \
  | jq -r '.tag_name | ltrimstr("v")')"

BASE_URL="https://github.com/mas-cli/mas/releases/download/v${VERSION}/mas-${VERSION}"

fetch_hash() {
    local arch="$1"
    nurl --hash --expr \
        "(import <nixpkgs> { }).fetchurl { url = \"${BASE_URL}-${arch}.pkg\"; }"
}

replace_hash() {
    sed -i "/$1.pkg\";/{n; s|hash = \"sha256-.\{44\}\"|hash = \"$2\"|}" "$NIX_DRV"
}

X86_HASH=$(fetch_hash "x86_64")
ARM_HASH=$(fetch_hash "arm64")

sed -i "s/version = \".*\"/version = \"$VERSION\"/" "$NIX_DRV"
replace_hash "x86_64" "$X86_HASH"
replace_hash "arm64" "$ARM_HASH"
