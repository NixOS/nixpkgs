#!/usr/bin/env nix-shell
#!nix-shell -p jq -i bash

cd "$(dirname "$0")"
nix-instantiate --eval --raw --expr 'builtins.toJSON (import ./generate.nix {})' | jq > generated.json
