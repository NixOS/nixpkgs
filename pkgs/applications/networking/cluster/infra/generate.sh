#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# Usage:
#    NIX_PATH=nixpkgs=<your local nixpkgs checkout> ./generate.sh

dst="$(pwd)"
src="$(nix-build '<nixpkgs>' -A infra.ui.src --no-out-link)"

cd "$src"

node2nix \
    --nodejs-16 \
    --development \
    --lock package-lock.json \
    --output "${dst}/node-packages.nix" \
    --node-env "${dst}/node-env.nix"

cd "$dst"
