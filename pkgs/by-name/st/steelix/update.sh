#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euo pipefail

echo "Updating steelix source to the latest commit from steel-event-system branch..."
nix-update steelix --version=branch=steel-event-system

echo "Done!"
