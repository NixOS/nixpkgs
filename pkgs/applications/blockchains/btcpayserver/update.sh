#!/usr/bin/env bash
set -euo pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)

"$scriptDir"/../nbxplorer/util/update-common.sh btcpayserver "$scriptDir"/deps.nix
