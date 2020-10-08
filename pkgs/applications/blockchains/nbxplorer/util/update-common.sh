#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq common-updater-scripts dotnet-sdk_3
set -euo pipefail

# This script uses the following env vars:
# getVersionFromTags
# onlyCreateDeps

pkgName=$1
depsFile=$2

: ${getVersionFromTags:=}
: ${onlyCreateDeps:=}

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../../..)

evalNixpkgs() {
  nix eval --raw "(with import \"$nixpkgs\" {}; $1)"
}

getRepo() {
  url=$(evalNixpkgs $pkgName.src.meta.homepage)
  echo $(basename $(dirname $url))/$(basename $url)
}

getLatestVersionTag() {
  "$nixpkgs"/pkgs/common-updater/scripts/list-git-tags https://github.com/$(getRepo) 2>/dev/null \
    | sort -V | tail -1 | sed 's|^v||'
}

if [[ ! $onlyCreateDeps ]]; then
  oldVersion=$(evalNixpkgs "$pkgName.version")
  if [[ $getVersionFromTags ]]; then
    newVersion=$(getLatestVersionTag)
  else
    newVersion=$(curl -s "https://api.github.com/repos/$(getRepo)/releases" | jq -r '.[0].name')
  fi

  if [[ $newVersion == $oldVersion ]]; then
    echo "nixpkgs already has the latest version $newVersion"
    echo "Run this script with env var onlyCreateDeps=1 to recreate "$(basename "$depsFile")
    exit 0
  else
    echo "Updating $pkgName: $oldVersion -> $newVersion"
    (cd "$nixpkgs" && update-source-version "$pkgName" "$newVersion")
  fi
fi

storeSrc="$(nix-build "$nixpkgs" -A $pkgName.src --no-out-link)"
. "$scriptDir"/create-deps.sh "$storeSrc" "$depsFile"
