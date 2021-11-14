#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix
# shellcheck shell=bash

# Download package.json and package-lock.json from the v0.3.3 release
curl https://raw.githubusercontent.com/dvallin/spacegun/f88cfd1cf653995a301ef4db4a1e387ef3ca01a1/package.json -o package.json
curl https://raw.githubusercontent.com/dvallin/spacegun/f88cfd1cf653995a301ef4db4a1e387ef3ca01a1/package-lock.json -o package-lock.json

node2nix \
  --nodejs-10 \
  --node-env ../../../../development/node-packages/node-env.nix \
  --development \
  --input package.json \
  --lock package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix

rm -f package.json package-lock.json
