#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils gnused curl jq
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

DRV_DIR="$PWD"

OLD_VERSION="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

NEW_VERSION="$(curl https://api.github.com/repos/p7zip-project/p7zip/releases/latest | jq .tag_name -r | tr -d 'v')"

echo "comparing versions $OLD_VERSION => $NEW_VERSION"
if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "Already up to date! Doing nothing"
    exit 0
fi

NIXPKGS_ROOT="$(realpath "$DRV_DIR/../../../..")"

echo "getting free source hash"
OLD_FREE_HASH="$(nix-instantiate --eval --strict -E "with import $NIXPKGS_ROOT {}; p7zip.src.drvAttrs.outputHash" | tr -d '"')"
echo "getting unfree source hash"
OLD_UNFREE_HASH="$(nix-instantiate --eval --strict -E "with import $NIXPKGS_ROOT {}; (p7zip.override { enableUnfree = true; }).src.drvAttrs.outputHash" | tr -d '"')"


NEW_FREE_HASH=$(nix-prefetch -f "$NIXPKGS_ROOT" -E "p7zip.src" --rev "v$NEW_VERSION")

NEW_UNFREE_OUT=$(nix-prefetch -f "$NIXPKGS_ROOT" -E "(p7zip.override { enableUnfree = true; }).src" --rev "v$NEW_VERSION" --output raw --print-path)
# first line of raw output is the hash
NEW_UNFREE_HASH="$(echo "$NEW_UNFREE_OUT" | sed -n 1p)"
# second line of raw output is the src path
NEW_UNFREE_SRC="$(echo "$NEW_UNFREE_OUT" | sed -n 2p)"
# make sure to nuke the unfree src from the updater's machine
# > the license requires that you agree to these use restrictions, or you must remove the software (source and binary) from your hard disks
# https://fedoraproject.org/wiki/Licensing:Unrar
nix-store --delete "$NEW_UNFREE_SRC"


echo "updating version"
sed -i "s/version = \"$OLD_VERSION\";/version = \"$NEW_VERSION\";/" "$DRV_DIR/default.nix"

echo "updating free hash"
sed -i "s@free = \"$OLD_FREE_HASH\";@free = \"$NEW_FREE_HASH\";@" "$DRV_DIR/default.nix"
echo "updating unfree hash"
sed -i "s@unfree = \"$OLD_UNFREE_HASH\";@unfree = \"$NEW_UNFREE_HASH\";@" "$DRV_DIR/default.nix"

echo "done"
