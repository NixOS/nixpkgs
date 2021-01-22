#!/usr/bin/env bash

node2nix=$(nix-build ../../../../.. --no-out-link -A nodePackages.node2nix)

${node2nix}/bin/node2nix \
  --nodejs-10 \
  --node-env ../../../../development/node-packages/node-env.nix \
  --development \
  --input package.json \
  --output node-packages.nix \
  --composition node-composition.nix
