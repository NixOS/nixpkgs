#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nurl nix-update python3

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating helix source to the latest stable..."
nix-update helix

echo "Fetching updated helixSource..."
HELIX_SRC=$(nix-instantiate --eval -A "helix.src.outPath" --raw)

echo "Generating grammars.json..."
"$SCRIPT_DIR/generate_grammars.py" \
  "$HELIX_SRC/languages.toml" \
  -o "$SCRIPT_DIR/grammars.json"

if [ $? -ne 0 ]; then
  echo "Error: Failed to generate grammars.json" >&2
  exit 1
fi

echo "Done! Updated grammars.json"
