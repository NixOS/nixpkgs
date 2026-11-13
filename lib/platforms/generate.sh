#!/usr/bin/env nix-shell
#!nix-shell -p jq -i bash
set -euo pipefail

cd "$(dirname "$0")"
json=$(nix-instantiate --eval --strict --json --expr 'import ./generate.nix { }' | jq .)
printf '%s\n' "$json" > generated.json
