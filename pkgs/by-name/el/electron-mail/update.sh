#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl gnused jq nix

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestVersion=$(curl --fail --silent https://api.github.com/repos/vladimiry/ElectronMail/releases/latest | jq --raw-output .tag_name | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; electron-mail.version" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "electron-mail is up-to-date: $currentVersion"
  exit 0
fi

echo "updating electron-mail: $currentVersion -> $latestVersion"

sed -i "s/version = \".*\"/version = \"${latestVersion}\"/" "$ROOT/package.nix"

APPIMAGE_URL="https://github.com/vladimiry/ElectronMail/releases/download/v${latestVersion}/electron-mail-${latestVersion}-linux-x86_64.AppImage"
APPIMAGE_HASH=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "$APPIMAGE_URL")")
sed -i "/linux-x86_64\.AppImage/,/hash/{s|hash = \".*\"|hash = \"${APPIMAGE_HASH}\"|}" "$ROOT/package.nix"

DMG_URL="https://github.com/vladimiry/ElectronMail/releases/download/v${latestVersion}/electron-mail-${latestVersion}-mac-arm64.dmg"
DMG_SHA=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "$DMG_URL")")
sed -i "/mac-arm64\.dmg/,/hash/{s|hash = \".*\"|hash = \"${DMG_SHA}\"|}" "$ROOT/package.nix"
