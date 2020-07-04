#!/usr/bin/env nix-shell
#!nix-shell -p nix bash -i bash
set -e
cd "$(dirname "$0")"
storepath="$(nix-build --no-out-link mkcerts.nix)"
cat "$storepath" > snakeoil-certs.nix
