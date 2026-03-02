#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts gnused nix coreutils

set -euo pipefail

latestVersion="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/ersatztv/ersatztv/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; ersatztv.version or (lib.getVersion ersatztv)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "ersatztv is up-to-date: $currentVersion"
  exit 0
fi

update-source-version ersatztv "$latestVersion"

$(nix-build . -A ersatztv.fetch-deps --no-out-link)
