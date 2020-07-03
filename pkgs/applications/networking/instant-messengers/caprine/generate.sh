#!/usr/bin/env nix-shell
#! nix-shell -i bash -I nixpkgs=../../../../.. -p nodePackages.node2nix

node2nix \
  --input node-packages.json \
  --output node-packages.nix \
  --composition node-composition.nix \
  --node-env ../../../../development/node-packages/node-env.nix \
  --no-copy-node-env \
  --development # See https://github.com/svanderburg/node2nix/issues/149
