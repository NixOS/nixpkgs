#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl p7zip nodePackages.asar jq

set -eu -o pipefail

scriptDir="$(dirname "$0")"
latestUrl="https://rs-launcher-updates.runescape.com/production/linux/x64/latest/jagex-launcher-beta-linux-x86_64.AppImage"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Download latest
curl -sLo "$tmpdir/jagex-launcher.AppImage" "$latestUrl"

# Extract version from embedded package.json
7z x -o"$tmpdir/extracted" "$tmpdir/jagex-launcher.AppImage" -bso0 -bsp0
asar extract "$tmpdir/extracted/resources/app.asar" "$tmpdir/app-src"
version=$(jq -r .version "$tmpdir/app-src/package.json")

# Compute SRI hash
sri=$(nix hash file --sri "$tmpdir/jagex-launcher.AppImage")

# Update package.nix in-place
sed -i \
  -e "s|^\(\s*version = \)\"[^\"]*\";|\1\"$version\";|" \
  -e "s|^\(\s*hash = \)\"[^\"]*\";|\1\"$sri\";|" \
  "$scriptDir/package.nix"

echo "jagex-launcher → $version"
echo "         hash: $sri"
