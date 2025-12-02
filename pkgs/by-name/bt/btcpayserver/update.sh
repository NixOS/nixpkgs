#!/usr/bin/env bash
set -euo pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
cd "$scriptDir"

echo "Updating nbxplorer"
../../nb/nbxplorer/update.sh
echo
echo "Updating btcpayserver"
../../nb/nbxplorer/util/update-common.sh btcpayserver deps.nix
