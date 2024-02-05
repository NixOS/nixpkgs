#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused jq
set -eu
cd "$(dirname "$(readlink -f "$0")")"/../../..

mkdir -p logs
for name in $(nix-env -qaP -f . -A kdePackages --json | jq -r 'to_entries[] | .key' | sed s/kdePackages.//); do
    echo "Processing ${name}..."
    path=$(nix eval ".#kdePackages.${name}.outPath" --json --option warn-dirty false | jq -r)
    if [ -n "${path}" ]; then
        nix-store --read-log "${path}" > "logs/${name}.log" || true
    fi
done
