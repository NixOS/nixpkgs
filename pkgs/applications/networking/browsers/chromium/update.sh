#!/bin/sh -e
sp="$(nix-build -Q --no-out-link source/update.nix -A update)"
cat "$sp" > source/sources.nix
