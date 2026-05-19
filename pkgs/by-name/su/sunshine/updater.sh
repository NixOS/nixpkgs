#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep curl jq nix-update
# shellcheck shell=bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../../../.."

version=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --location https://api.github.com/repos/LizardByte/Sunshine/releases/latest | jq --raw-output .tag_name | grep -oP "^v\K.*")

if [[ "${UPDATE_NIX_OLD_VERSION:-}" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

nix-update sunshine --version "$version"
# `--generate-lockfile` only regenerates package-lock.json; it skips the npmDepsHash
# refresh (see nix-update's dependency_hashes.py). Run a second pass to update the hash.
nix-update sunshine --version=skip --generate-lockfile --subpackage ui
nix-update sunshine --version=skip --subpackage ui
