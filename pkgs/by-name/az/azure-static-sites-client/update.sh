#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl

set -euo pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

curl -O --silent --output-dir "${SCRIPT_DIRECTORY}" 'https://swalocaldeploy.azureedge.net/downloads/versions.json'
echo "" >> "${SCRIPT_DIRECTORY}/versions.json"
