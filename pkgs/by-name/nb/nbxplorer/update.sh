#!/usr/bin/env bash
set -euo pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)

getVersionFromTags=1 "$scriptDir"/util/update-common.sh nbxplorer "$scriptDir"/deps.nix
