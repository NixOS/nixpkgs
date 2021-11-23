#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix
# shellcheck shell=bash

node2nix \
  --node-env node-env.nix \
  --input package.json \
  --output node-packages.nix \
  --composition node-composition.nix
