#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

exec node2nix --development --nodejs-12 -i pkg.json -c hotel.nix -e ../../../../development/node-packages/node-env.nix --no-copy-node-env
