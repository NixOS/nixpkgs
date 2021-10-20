#!/usr/bin/env bash
set -euo pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
cd "$scriptDir"

echo "Updating nbxplorer"
../nbxplorer/update.sh
echo
echo "Updating btcpayserver"
# Include Razor SDK packages in deps.nix
../nbxplorer/util/update-common.sh btcpayserver deps.nix '"/p:Configuration="Altcoins-Release" /p:RazorCompileOnBuild=false'
