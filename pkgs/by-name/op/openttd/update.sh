#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl yq-go common-updater-scripts

set -euo pipefail

latest() {
  curl -fsSL "https://cdn.openttd.org/$1-releases/latest.yaml" | yq '.latest[] | select(.name == "stable") | .version'
}

update-source-version openttd "$(latest openttd)"

for baseset in opengfx opensfx openmsx; do
  update-source-version openttd "$(latest "$baseset")" --version-key="$baseset-version" --source-key="$baseset"
done
