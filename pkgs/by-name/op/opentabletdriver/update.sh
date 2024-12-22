#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash nix nix-update git cacert
set -euo pipefail

prev_version=$(nix eval --raw -f. opentabletdriver.version)
nix-update opentabletdriver
[[ $(nix eval --raw -f. opentabletdriver.version) == "$prev_version" ]] ||
  "$(nix-build . -A opentabletdriver.fetch-deps --no-out-link)"
