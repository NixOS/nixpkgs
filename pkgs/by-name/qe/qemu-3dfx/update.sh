#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix coreutils gnused gnugrep git

# Bump qemu-3dfx to the latest kjliew/qemu-3dfx commit on master and
# the latest qemu 9.2.x point release. Edits the five pinned values
# (qemu3dfxRev/Hash/Date, qemuVersion/Hash) at the top of package.nix.

set -euo pipefail
export NIX_CONFIG="experimental-features = nix-command"

pkg="$(dirname "$(readlink -f "$0")")/package.nix"

sriHashUrl() {
  local hex
  hex=$(nix-prefetch-url --type sha256 "$@" 2>/dev/null | tail -1)
  nix hash convert --to sri --hash-algo sha256 "$hex"
}

setLetBinding() {
  sed -i -E "s|^(  $1 = \")[^\"]*(\";)\$|\1$2\2|" "$pkg"
}

echo "Resolving latest kjliew/qemu-3dfx HEAD..."
commit=$(curl -fsSL https://api.github.com/repos/kjliew/qemu-3dfx/commits/master)
rev=$(jq -r .sha <<<"$commit")
date=$(jq -r '.commit.committer.date[:10]' <<<"$commit")
echo "  rev   $rev"
echo "  date  $date"

echo "Hashing kjliew/qemu-3dfx@${rev:0:7}..."
srcHash=$(sriHashUrl --unpack "https://github.com/kjliew/qemu-3dfx/archive/$rev.tar.gz")
echo "  hash  $srcHash"

echo "Resolving latest qemu 9.2.x point release..."
# git ls-remote on the upstream qemu repo, not the directory index at
# download.qemu.org — the latter has a long-standing bug that omits
# 9.2.x entries from the listing even though the files do exist.
qver=$(git ls-remote --tags https://gitlab.com/qemu-project/qemu.git 'v9.2.*' |
  grep -oE 'v9\.2\.[0-9]+$' | sort -Vu | tail -1 | sed 's|^v||')
echo "  ver   $qver"

echo "Hashing qemu-$qver.tar.xz..."
qHash=$(sriHashUrl "https://download.qemu.org/qemu-$qver.tar.xz")
echo "  hash  $qHash"

echo "Updating $pkg..."
setLetBinding qemu3dfxRev  "$rev"
setLetBinding qemu3dfxHash "$srcHash"
setLetBinding qemu3dfxDate "$date"
setLetBinding qemuVersion  "$qver"
setLetBinding qemuHash     "$qHash"

echo "Done. Diff:"
git --no-pager diff -- "$pkg"
