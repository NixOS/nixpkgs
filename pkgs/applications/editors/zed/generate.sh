#!/bin/sh -e

node2nix -i package.json -c zed.nix -e ../../../development/node-packages/node-env.nix