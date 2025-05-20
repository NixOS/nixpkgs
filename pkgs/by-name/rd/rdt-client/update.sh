#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts gnused nix coreutils

set -euo pipefail

latestVersion="$(curl -s "https://api.github.com/repos/rogerfar/rdt-client/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; rdt-client.version or (lib.getVersion rdt-client)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "rdt-client is up-to-date: $currentVersion"
  exit 0
fi

update-source-version rdt-client "$latestVersion"

$(nix-build . -A rdt-client.fetch-deps --no-out-link)
