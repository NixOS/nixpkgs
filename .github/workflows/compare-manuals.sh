#!/usr/bin/env nix-shell
#! nix-shell -i bash -p html-tidy

set -euo pipefail
shopt -s inherit_errexit

normalize() {
  tidy \
      --anchor-as-name no \
      --coerce-endtags no \
      --escape-scripts no \
      --fix-backslash no \
      --fix-style-tags no \
      --fix-uri no \
      --indent yes \
      --wrap 0 \
      < "$1" \
      2> /dev/null
}

diff -U3 <(normalize "$1") <(normalize "$2")
