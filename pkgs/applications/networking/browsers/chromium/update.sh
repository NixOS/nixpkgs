#!/bin/sh -e
cd "$(dirname "$0")"
sp="$(nix-build --builders "" -Q --no-out-link update.nix -A update)"
cat "$sp" > upstream-info.nix
