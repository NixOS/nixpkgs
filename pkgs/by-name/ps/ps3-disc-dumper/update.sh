#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash nix nix-update git cacert
set -eo pipefail

prev_version=$(nix eval --raw -f. ps3-disc-dumper.version)
nix-update ps3-disc-dumper
[[ $(nix eval --raw -f. ps3-disc-dumper.version) == "$prev_version" ]] ||
  $(nix-build . -A ps3-disc-dumper.fetch-deps --no-out-link)
