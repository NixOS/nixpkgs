#!/usr/bin/env bash

# Run:
#   ./test.sh
# or:
#   nix-build -A nixosTests.activation-lib

cd "$(dirname "${BASH_SOURCE[0]}")"
set -euo pipefail

# report failure
onerr() {
  set +e
  # find failed statement
  echo "call trace:"
  local i=0
  while t="$(caller $i)"; do
    line="${t%% *}"
    file="${t##* }"
    echo "  $file:$line" >&2
    ((i++))
  done
  # red
  printf "\033[1;31mtest failed\033[0m\n" >&2
  exit 1
}
trap onerr ERR

source ./lib.sh

(warn hi, this works >/dev/null) 2>&1 | grep -E $'.*warning:.* hi, this works' >/dev/null

# green
printf "\033[1;32mok\033[0m\n"
