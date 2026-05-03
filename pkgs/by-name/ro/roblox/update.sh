#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix

set -euo pipefail

RESPONSE="$(curl -fsSL "https://clientsettingscdn.roblox.com/v1/client-version/MacPlayer")"
VERSION="$(echo "$RESPONSE" | jq -r '.version')"
CLIENT_UPLOAD="$(echo "$RESPONSE" | jq -r '.clientVersionUpload' | sed 's/version-//')"
NIX_FILE="$(dirname "$0")/package.nix"

prefetch() {
  nix-prefetch-url --unpack "$1" 2>/dev/null \
    | xargs -I{} nix hash convert --hash-algo sha256 --to sri {}
}

ARM_HASH="$(prefetch "https://setup.rbxcdn.com/mac/arm64/version-${CLIENT_UPLOAD}-RobloxPlayer.zip")"
X86_HASH="$(prefetch "https://setup.rbxcdn.com/mac/version-${CLIENT_UPLOAD}-RobloxPlayer.zip")"
OLD_UPLOAD="$(grep -oE '[0-9a-f]{16}' "$NIX_FILE" | head -1)"

sed -i \
  -e "s/$OLD_UPLOAD/$CLIENT_UPLOAD/" \
  -e "s|version = \"[^\"]*\"|version = \"$VERSION\"|" \
  -e "s|aarch64-darwin = \"sha256-[^\"]*\"|aarch64-darwin = \"$ARM_HASH\"|" \
  -e "s|x86_64-darwin = \"sha256-[^\"]*\"|x86_64-darwin = \"$X86_HASH\"|" \
  "$NIX_FILE"
