#!/usr/bin/env nix-shell
#!nix-shell -i bash -I nixpkgs=../

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

nix --extra-experimental-features 'nix-command flakes' \
  flake update . --commit-lock-file
