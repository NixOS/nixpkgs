#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")"; cd -P "$(dirname "$(readlink "${BASH_SOURCE[0]}" || echo .)")"; pwd)

getVersionFromTags=1 "$SCRIPT_DIRECTORY"/util/update-common.sh nbxplorer "$SCRIPT_DIRECTORY"/deps.nix
