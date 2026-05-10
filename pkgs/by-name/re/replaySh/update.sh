#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p nix-update

set -euo pipefail

nix-update replaySh
