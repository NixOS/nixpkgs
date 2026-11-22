#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts gnused nix coreutils

set -euo pipefail

latestVersion="$(curl -s "https://api.github.com/repos/SkEditorTeam/skEditor/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; skeditor.version or (lib.getVersion skeditor)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "skeditor is up-to-date: $currentVersion"
  exit 0
fi

update-source-version skeditor "$latestVersion"

$(nix-build . -A skeditor.fetch-deps --no-out-link)
