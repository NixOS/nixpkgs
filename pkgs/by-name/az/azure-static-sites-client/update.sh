#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl

set -euo pipefail

dirname="$(dirname "$0")"

curl -O --silent --output-dir "$dirname" 'https://swalocaldeploy.azureedge.net/downloads/versions.json'
echo "" >> "$dirname/versions.json"
