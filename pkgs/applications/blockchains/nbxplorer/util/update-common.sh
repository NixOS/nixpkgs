#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq common-updater-scripts dotnet-sdk_6 git gnupg nixFlakes
set -euo pipefail

# This script uses the following env vars:
# getVersionFromTags
# refetch

trap 'echo "Error at ${BASH_SOURCE[0]}:$LINENO"' ERR

pkgName=$1
depsFile=$2

: ${getVersionFromTags:=}
: ${refetch:=}

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../../..)

evalNixpkgs() {
  nix eval --impure --raw --expr "(with import \"$nixpkgs\" {}; $1)"
}

getRepo() {
  url=$(evalNixpkgs $pkgName.src.meta.homepage)
  echo $(basename $(dirname $url))/$(basename $url)
}

getLatestVersionTag() {
  "$nixpkgs"/pkgs/common-updater/scripts/list-git-tags --url=https://github.com/$(getRepo) 2>/dev/null \
    | sort -V | tail -1 | sed 's|^v||'
}

oldVersion=$(evalNixpkgs "$pkgName.version")
if [[ $getVersionFromTags ]]; then
  newVersion=$(getLatestVersionTag)
else
  newVersion=$(curl -s "https://api.github.com/repos/$(getRepo)/releases" | jq -r '.[0].name')
fi

if [[ $newVersion == $oldVersion && ! $refetch ]]; then
  echo "nixpkgs already has the latest version $newVersion"
  echo "Run this script with env var refetch=1 to re-verify the content hash via GPG"
  echo "and to recreate $(basename "$depsFile"). This is useful for reviewing a version update."
  exit 0
fi

# Fetch release and GPG-verify the content hash
tmpdir=$(mktemp -d /tmp/$pkgName-verify-gpg.XXX)
repo=$tmpdir/repo
trap "rm -rf $tmpdir" EXIT
git clone --depth 1 --branch v${newVersion} -c advice.detachedHead=false https://github.com/$(getRepo) $repo
export GNUPGHOME=$tmpdir
# Fetch Nicolas Dorier's key (64-bit key ID: 6618763EF09186FE)
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys AB4CFA9895ACA0DBE27F6B346618763EF09186FE 2> /dev/null
# Fetch Andrew Camilleri's key (64-bit key ID: 8E5530D9D1C93097)
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 836C08CF3F523BB7A8CB8ECF8E5530D9D1C93097 2> /dev/null
echo
echo "Verifying commit"
git -C $repo verify-commit HEAD
rm -rf $repo/.git
newHash=$(nix hash-path $repo)
rm -rf $tmpdir
echo

# Update pkg version and hash
echo "Updating $pkgName: $oldVersion -> $newVersion"
if [[ $newVersion == $oldVersion ]]; then
  # Temporarily set a source version that doesn't equal $newVersion so that $newHash
  # is always updated in the next call to update-source-version.
  (cd "$nixpkgs" && update-source-version "$pkgName" "0" "0000000000000000000000000000000000000000000000000000")
fi
(cd "$nixpkgs" && update-source-version "$pkgName" "$newVersion" "$newHash")
echo

# Create deps file
$(nix-build "$nixpkgs" -A $pkgName.fetch-deps --no-out-link) "$depsFile"
