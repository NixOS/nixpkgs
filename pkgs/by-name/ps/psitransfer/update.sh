#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euo pipefail

nix-update psitransfer --src-only --version-regex='^v(\d+\.\d+\.\d+)$'
nix-update psitransfer.app --version=skip
nix-update psitransfer --version=skip
