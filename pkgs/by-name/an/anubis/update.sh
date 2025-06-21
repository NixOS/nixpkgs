#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euo pipefail

nix-update anubis --src-only --version-regex='^v(\d+\.\d+\.\d+)$'
nix-update anubis.xess --version=skip
nix-update anubis --version=skip
