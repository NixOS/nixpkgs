#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash actionlint shellcheck -I nixpkgs=../..
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR/../.."
actionlint
