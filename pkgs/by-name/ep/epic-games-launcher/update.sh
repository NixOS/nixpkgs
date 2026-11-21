#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

# The public download link always points to the latest build and redirects
# to a versioned URL like .../Builds/EGLv2/<version>%2B<build>/Linux/...
location=$(curl -sI https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher-x86_64.AppImage \
  | grep -i '^location:' | tr -d '\r')

if [[ ! $location =~ /Builds/EGLv2/([^/]+)%2B([^/]+)/Linux/ ]]; then
  echo "unexpected redirect: $location" >&2
  exit 1
fi
version=${BASH_REMATCH[1]}
build=${BASH_REMATCH[2]}

current=$(nix-instantiate --eval --raw -A epic-games-launcher.version)
if [[ $version == "$current" ]]; then
  echo "epic-games-launcher is already up to date ($version)"
  exit 0
fi

file=$(dirname "${BASH_SOURCE[0]}")/package.nix
sed -i "s/build = \"[^\"]*\";/build = \"$build\";/" "$file"
update-source-version epic-games-launcher "$version"
