#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts git gnused gnugrep coreutils
set -euo pipefail

repo="https://git.code.sf.net/p/psrdada/code"

# Get tags, strip refs/tags/ prefix, filter to numeric x.y.z, sort semver-aware, take latest
latest=$(git ls-remote --tags --refs "$repo" \
    | awk '{print $2}' \
    | sed 's|refs/tags/||' \
    | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
    | sort -V \
    | tail -n1)

if [[ -z "$latest" ]]; then
    echo "No tags found" >&2
    exit 1
fi

# UPDATE_NIX_ATTR_PATH is set by nixpkgs' update.nix runner
update-source-version "${UPDATE_NIX_ATTR_PATH:-psrdada}" "$latest"
