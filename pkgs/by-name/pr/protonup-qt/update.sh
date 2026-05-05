#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

update-source-version protonup-qt $(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/DavidoTek/ProtonUp-Qt/releases/latest | jq -r ".tag_name" | tr -d v)
