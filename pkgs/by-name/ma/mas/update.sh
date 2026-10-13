#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nurl gnused

set -eu

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"

VERSION="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/mas-cli/mas/releases/latest \
  | jq -r '.tag_name | ltrimstr("v")')"

URL="https://github.com/mas-cli/mas/releases/download/v${VERSION}/mas-${VERSION}-arm64.pkg"
HASH=$(nurl --hash --expr \
    "(import <nixpkgs> { }).fetchurl { url = \"$URL\"; }")

sed -i "s/version = \".*\"/version = \"$VERSION\"/" "$NIX_DRV"
sed -i "/arm64.pkg\";/{n; s|hash = \"sha256-.\{44\}\"|hash = \"$HASH\"|}" "$NIX_DRV"
