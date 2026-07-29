#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p nix git gnused coreutils

set -euo pipefail

dir=$(dirname "$(readlink -f "$0")")
pkg=$dir/package.nix
nixpkgs=$(readlink -f "$dir/../../../..")

# Reads `  <name> = "<value>";` from package.nix.
getVar() {
  sed -n "s/^  $1 = \"\(.*\)\";\$/\1/p" "$pkg"
}

setVar() {
  sed -i "s|^  $1 = \".*\";\$|  $1 = \"$2\";|" "$pkg"
}

prefetchSri() {
  nix hash convert --hash-algo sha256 --to sri \
    "$(nix-prefetch-url --unpack --type sha256 "$1" 2>/dev/null)"
}

# latestTag <owner/repo> <ref glob> <regex>
latestTag() {
  local tag
  tag=$(git ls-remote --tags --refs "https://github.com/$1" "refs/tags/$2" |
    sed 's|.*refs/tags/||' |
    grep -E "$3" |
    sort -V |
    tail -1)

  if [[ -z $tag ]]; then
    echo "netcoredbg: no release tag matching '$2' in $1" >&2
    return 1
  fi
  printf '%s\n' "$tag"
}

oldRelease=$(getVar release)
oldBuild=$(getVar build)
oldCoreclr=$(getVar coreclr-version)

# netcoredbg tags its releases `<release>-<build>`, e.g. `3.2.0-1092`.
latest=$(latestTag Samsung/netcoredbg '*' '^[0-9]+\.[0-9]+\.[0-9]+-[0-9]+$')
newRelease=${latest%-*}
newBuild=${latest##*-}

series=${oldCoreclr%.*}
newCoreclr=$(latestTag dotnet/runtime "$series.*" '^v[0-9]+\.[0-9]+\.[0-9]+$')

changed=0

if [[ $latest != "$oldRelease-$oldBuild" ]]; then
  echo "netcoredbg: $oldRelease-$oldBuild -> $latest"
  setVar release "$newRelease"
  setVar build "$newBuild"
  setVar hash "$(prefetchSri "https://github.com/Samsung/netcoredbg/archive/refs/tags/$latest.tar.gz")"
  changed=1
else
  echo "netcoredbg: already at $oldRelease-$oldBuild"
fi

if [[ $newCoreclr != "$oldCoreclr" ]]; then
  echo "netcoredbg: coreclr $oldCoreclr -> $newCoreclr"
  setVar coreclr-version "$newCoreclr"
  setVar coreclr-hash "$(prefetchSri "https://github.com/dotnet/runtime/archive/refs/tags/$newCoreclr.tar.gz")"
  changed=1
else
  echo "netcoredbg: coreclr already at $oldCoreclr"
fi

if ((changed == 0)); then
  exit 0
fi

echo "netcoredbg: regenerating deps.json"
"$(nix-build "$nixpkgs" --attr netcoredbg.fetch-deps --no-out-link)"
