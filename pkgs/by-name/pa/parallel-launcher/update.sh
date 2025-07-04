#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused common-updater-scripts

set -euo pipefail

nixpkgs=$(git rev-parse --show-toplevel)
packageDir="$nixpkgs/pkgs/by-name/pa/parallel-launcher"

getLatestVersion() {
  curl -s "https://gitlab.com/api/v4/projects/parallel-launcher%2F$1/repository/tags" \
  | jq -r '.[0] | select(.) | .name' \
  | sed 's|v||' \
  | sed 's|-|.|'
}

updateSourceVersion() {
  update-source-version "$1" "$2" --file="$3" --print-changes
}

latestLauncherVersion=$(getLatestVersion parallel-launcher)
latestCoreVersion=$(getLatestVersion parallel-n64)

launcherUpdate=$(updateSourceVersion parallel-launcher "$latestLauncherVersion" "$packageDir/package.nix")
coreUpdate=$(updateSourceVersion parallel-launcher.parallel-n64-core "$latestCoreVersion" "$packageDir/parallel-n64-next.nix")

echo '[]' | jq ". += $launcherUpdate + $coreUpdate"
