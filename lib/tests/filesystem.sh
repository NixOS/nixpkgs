#!/usr/bin/env bash
set -euo pipefail

# Use
#     || die
die() {
  echo >&2 "test case failed: " "$@"
  exit 1
}

cd "$(dirname ${BASH_SOURCE[0]})"

nix-instantiate --eval --json --show-trace filesystem-test.nix >/dev/null || die filesystem-test.nix

echo tests ok
