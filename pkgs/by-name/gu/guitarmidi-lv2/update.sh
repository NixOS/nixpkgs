#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash python3 curl jq common-updater-scripts nix

set -euo pipefail

dirname=$(dirname "$0")
python3 "$dirname/update.py"
