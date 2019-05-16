#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bundix bundler

SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")

cd $SCRIPT_DIR

bundle lock --update
bundix
