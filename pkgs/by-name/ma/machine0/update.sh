#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs nix-update

set -euo pipefail

nix-update machine0 --version "$(npm view @machine0/cli version)"
