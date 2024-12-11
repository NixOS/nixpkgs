#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash nix nix-update git cacert
set -euo pipefail

nix-update kryptor
$(nix-build . -A kryptor.fetch-deps --no-out-link)
