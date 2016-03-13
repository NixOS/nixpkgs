#!/bin/sh -e
cd "$(dirname "$0")"
sp="$(nix-build -Q --no-out-link source/update.nix -A update)"
cat "$sp" > source/sources.nix
