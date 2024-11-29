#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch-svn git curl
set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
path="$nixpkgs/pkgs/os-specific/linux/kernel/linux-libre.nix"

old_rev="$(grep -o 'rev = ".*"' "$path" | awk -F'"' '{print $2}')"
old_sha256="$(grep -o 'sha256 = ".*"' "$path" | awk -F'"' '{print $2}')"

svn_url=https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/branches/
rev="$(curl -s "$svn_url" | grep -Em 1 -o 'Revision [0-9]+' | awk '{print $2}')"

if [ "$old_rev" = "$rev" ]; then
    echo "No updates for linux-libre"
    exit 0
fi

sha256="$(QUIET=1 nix-prefetch-svn "$svn_url" "$rev" | tail -1)"

if [ "$old_sha256" = "$sha256" ]; then
    echo "No updates for linux-libre"
    exit 0
fi

sed -i -e "s/rev = \".*\"/rev = \"$rev\"/" \
    -e "s/sha256 = \".*\"/sha256 = \"$sha256\"/" "$path"

if [ -n "${COMMIT-}" ]; then
    git commit -qm "linux_latest-libre: $old_rev -> $rev" "$path" \
       $nixpkgs/pkgs/os-specific/linux/kernel/linux-libre.nix
    echo "Updated linux_latest-libre $old_rev -> $rev"
fi
