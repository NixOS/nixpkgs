#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update common-updater-scripts

set -euo pipefail

nix-update olivetin --src-only --version-regex '^(2\d+\.\d+\.\d+)$'
update-source-version olivetin --source-key=gen --ignore-same-version
update-source-version olivetin --source-key=webui.npmDeps --ignore-same-version
update-source-version olivetin --source-key=goModules --ignore-same-version
