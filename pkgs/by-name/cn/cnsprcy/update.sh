#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update common-updater-scripts gnused

set -euo pipefail

version=$(list-git-tags --url="https://git.sr.ht/~xaos/cnsprcy" | sed -En 's/^cnspr\/v(.*)/\1/p' | tail -1)
nix-update cnsprcy --version="$version"
