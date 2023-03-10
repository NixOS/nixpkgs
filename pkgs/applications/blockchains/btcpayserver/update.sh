#!/usr/bin/env bash
set -euo pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
cd "$scriptDir"

echo "Updating nbxplorer"
../nbxplorer/update.sh
echo
echo "Updating btcpayserver"
../nbxplorer/util/update-common.sh btcpayserver deps.nix
