#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p common-updater-scripts curl

set -euo pipefail

# update-source-version and `nix eval -f .` both work relative to the current
# directory, so make sure we are at the nixpkgs root.
cd "$(dirname "$0")/../../../.."

# jagex-launcher is unfree, which check-meta honours through this variable.
export NIXPKGS_ALLOW_UNFREE=1

package="jagex-launcher"

# The launcher's electron-updater feed pins the current release. The AppImage
# itself is only published under releases/<version>/, so there is no "latest"
# redirect to read the version from.
feedUrl="https://rs-launcher-updates.runescape.com/production/latest-linux.yml"
latestVersion=$(curl -fsSL "$feedUrl" | sed -n 's/^version: *//p')

if [[ -z "$latestVersion" ]]; then
  echo "Could not parse the latest version from $feedUrl" >&2
  exit 1
fi

currentVersion=$(nix eval --raw -f . "$package.version")

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "$package is already up-to-date: $currentVersion"
  exit 0
fi

echo "Updating $package from $currentVersion to $latestVersion"
update-source-version "$package" "$latestVersion"
