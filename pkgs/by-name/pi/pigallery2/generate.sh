#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# Run this script not via `./generate.sh`, but via `$PWD/generate.sh`.
# Else `nix-shell` will not find this script.

set -euo pipefail

cd -- "$(dirname -- "$BASH_SOURCE[0]")"

node2nix \
     --input node-packages.json \
     --output node-packages-generated.nix \
     --composition node-packages.nix \
     --node-env ../../../development/node-packages/node-env.nix
