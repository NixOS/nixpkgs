#!/usr/bin/env nix
#!nix shell -f ``<nixpkgs>`` curl jq libplist _7zz common-updater-scripts -c bash

set -euo pipefail

macos_version="26_0"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

dmg="$tmpdir/Orion.dmg"
curl -fsSL -o "$dmg" "https://cdn.kagi.com/downloads/$macos_version/Orion.dmg"
version="$(
  7zz e -so "$dmg" "Orion/Orion.app/Contents/Info.plist" \
    | plistutil -i - -f json -o - \
    | jq -r '.CFBundleVersion'
)"

if [[ -z "$version" ]]; then
  echo "[update] Failed to read Orion version from Info.plist" >&2
  exit 1
fi

zip="$tmpdir/Orion.zip"
curl -fsSL -o "$zip" "https://cdn.kagi.com/updates/$macos_version/$version.zip"
hash="$(nix hash file --type sha256 --sri "$zip")"

update-source-version orion-browser "$version" "$hash"
