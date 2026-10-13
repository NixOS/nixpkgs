#!/usr/bin/env nix-shell
#!nix-shell -i bash -E 'with import ../. {}; mkShell { packages = [ npins ]; }'

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

npins --lock-file pinned.json upgrade
npins --lock-file pinned.json update
