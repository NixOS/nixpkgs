#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq common-updater-scripts
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

new_version="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/JustArchiNET/ArchiSteamFarm/releases" | jq -r  'map(select(.prerelease == false)) | .[0].tag_name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  if [[ "${1-default}" != "--deps-only" ]]; then
    exit 0
  fi
fi

asf_path=$PWD
cd ../../../..

if [[ "${1:-}" != "--deps-only" ]]; then
    update-source-version ArchiSteamFarm "$new_version"
fi

$(nix-build -A ArchiSteamFarm.fetch-deps --no-out-link)

cd "$asf_path/web-ui"
./update.sh
