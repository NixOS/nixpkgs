#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts gnused

set -euo pipefail

url="https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher-x86_64.AppImage"

location="$(curl -fsSI "$url" | tr -d '\r' | sed -n 's/^[Ll]ocation: //p' | tail -n1)"

if [[ -z "$location" ]]; then
  echo "Could not find download redirect" >&2
  exit 1
fi

version="$(printf '%s\n' "$location" |
  sed -nE 's|.*/Builds/EGLv2/([^/]+)/Linux/.*|\1|p')"

version="${version//%2B/+}"
version="${version//%2b/+}"

if [[ -z "$version" ]]; then
  echo "Could not extract version from: $location" >&2
  exit 1
fi

update-source-version "$UPDATE_NIX_PNAME" "$version"
