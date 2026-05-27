#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update common-updater-scripts

set -euo pipefail

nix-update silverbullet --src-only --override-filename
update-source-version silverbullet --source-key=frontend.npmDeps --ignore-same-version
update-source-version silverbullet --source-key=goModules --ignore-same-version
