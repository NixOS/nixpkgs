#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p nix common-updater-scripts coreutils curl gnugrep gnused

set -euo pipefail

NIXPKGS_DIR="$PWD"

RELEASES=$(
    curl -fsSL --compressed https://didierstevens.com/files/software/ |
        grep -o 'href="pdfid_v.*\.zip"' |
        sed -rn 's/href="pdfid_v(.*)\.zip"/\1/p' |
        sed 's/_/./g' |
        sort -uV
)

LATEST_VERSION=$(echo "$RELEASES" | tail -1)
OLD_VERSION=${UPDATE_NIX_OLD_VERSION:-$(nix eval --raw -f "$NIXPKGS_DIR" pdfid.version)}

if [[ "$OLD_VERSION" == "$LATEST_VERSION" ]]; then
    echo "Pdfid is up-to-date: $OLD_VERSION"
    exit 0
fi

>&2 echo "Updating Pdfid from $OLD_VERSION to $LATEST_VERSION."

update-source-version "${UPDATE_NIX_ATTR_PATH:-pdfid}" "$LATEST_VERSION"
