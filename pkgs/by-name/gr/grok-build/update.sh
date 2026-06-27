#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts
set -euo pipefail
latest=$(curl -fsSL "https://storage.googleapis.com/grok-build-public-artifacts/cli/stable")
update-source-version grok-build "$latest" \
  --source-key=src \
  --ignore-same-version
