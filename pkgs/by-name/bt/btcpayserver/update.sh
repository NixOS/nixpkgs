#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

cd -- "${SCRIPT_DIRECTORY}"

echo "Updating nbxplorer"
../../nb/nbxplorer/update.sh
echo
echo "Updating btcpayserver"
../../nb/nbxplorer/util/update-common.sh btcpayserver deps.nix
