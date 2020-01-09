#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

set -eu -o pipefail

exec node2nix \
    --nodejs-10 \
    --development \
    -i package.json \
    -o node-packages.nix \
    -c loleaflet-deps.nix \
    --no-copy-node-env \
    -e ../../../../development/node-packages/node-env.nix
