#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update common-updater-scripts

set -euo pipefail

nix-update olivetin-3k --src-only --override-filename
update-source-version olivetin-3k --source-key=gen --ignore-same-version
update-source-version olivetin-3k --source-key=webui.npmDeps --ignore-same-version
update-source-version olivetin-3k --source-key=goModules --ignore-same-version
