#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
set -euo pipefail

version="$(curl -fsSL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/ONLYOFFICE/DesktopEditors/releases?per_page=1" | jq -er ".[0].tag_name" | sed 's/^v//')"
update-source-version onlyoffice-desktopeditors.derivation "$version"
