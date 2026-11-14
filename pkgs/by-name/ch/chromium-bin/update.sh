#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p cacert common-updater-scripts curl git jq libplist nix unzip
# shellcheck shell=bash

set -euo pipefail

attr=chromium-bin
nix_file=./pkgs/by-name/ch/chromium-bin/package.nix
base_url="https://commondatastorage.googleapis.com/chromium-browser-snapshots"
arch=Mac_Arm

revision="$(curl --fail --location --silent --show-error "$base_url/$arch/LAST_CHANGE")"
url="$base_url/$arch/$revision/chrome-mac.zip"

prefetch="$(nix --extra-experimental-features nix-command store prefetch-file --json --name chrome-mac.zip "$url")"
hash="$(jq --raw-output .hash <<< "$prefetch")"
zip="$(jq --raw-output .storePath <<< "$prefetch")"

version="$(
  unzip -p "$zip" chrome-mac/Chromium.app/Contents/Info.plist \
    | plistutil -i - -f json -o - \
    | jq --raw-output .CFBundleShortVersionString
)"

if [[ -z "$version" || "$version" = null ]]; then
  echo "could not determine the Chromium version from $url" >&2
  exit 1
fi

update-source-version "$attr" "$version" "$hash" "$url" --file="$nix_file"
