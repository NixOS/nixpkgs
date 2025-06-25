#!/usr/bin/env nix-shell
#!nix-shell -i bash -p npins

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

npins --lock-file pinned.json update
