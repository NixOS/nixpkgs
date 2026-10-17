#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq common-updater-scripts git gnupg
set -euo pipefail

# This script uses the following env vars:
# getVersionFromTags
# refetch

trap 'echo "Error at ${BASH_SOURCE[0]}:$LINENO"' ERR

pkgName=$1

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
  echo "and to recreate deps.nix. This is useful for reviewing a version update."
  exit 0
fi

# Fetch release and GPG-verify the content hash
tmpdir=$(mktemp -d /tmp/$pkgName-verify-gpg.XXX)
repo=$tmpdir/repo
trap "rm -rf $tmpdir" EXIT
git clone --depth 1 --branch v${newVersion} -c advice.detachedHead=false https://github.com/$(getRepo) $repo
export GNUPGHOME=$tmpdir
importKey() {
  curl --fail --location --silent --show-error --retry 3 --retry-all-errors \
    "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x$1" \
    | gpg --batch --import
}

# Oliver Gugger's key
importKey F4FC70F07310028424EFC20A8E4256593F177720

# András Bánki-Horváth's key
importKey 9FC6B0BFD597A94DBF09708280E5375C094198D8

# Calvin Zachman's key
importKey A86BB204A87AD277C2CEFFAB52AAA845E345D42E

# djkazic's key
importKey B1216AF49F6F0DBA1357F8AF511B7BDA931A770F

echo
echo "Verifying commit"

# CAREFUL: The last correctly signed *tag* seems to be `v0.1.29-beta`. For
# newer tags there seems to be no maintainer signature at all.
git -C $repo verify-commit HEAD

rm -rf $repo/.git
newHash=$(nix --extra-experimental-features nix-command hash path $repo)
rm -rf $tmpdir
echo

# Update pkg version and hash
echo "Updating $pkgName: $oldVersion -> $newVersion"
(cd "$nixpkgs" && update-source-version "$pkgName" "$newVersion" "$newHash" --ignore-same-version)
echo
