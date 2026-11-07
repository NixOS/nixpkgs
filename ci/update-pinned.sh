#!/usr/bin/env nix-shell
#!nix-shell -i bash -E 'with import ../. {}; mkShell { packages = [ npins ]; }'

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

nix --extra-experimental-features 'nix-command flakes' \
  flake update --commit-lock-file
