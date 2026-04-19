#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils git gnugrep gnused gawk common-updater-scripts

set -euo pipefail

script_dir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$script_dir"/../../../..)
attrPath="${UPDATE_NIX_ATTR_PATH:-geph}"

if [[ -n "${UPDATE_NIX_OLD_VERSION:-}" ]]; then
  oldVersion="$UPDATE_NIX_OLD_VERSION"
else
  oldVersion=$(cd "$nixpkgs" && nix-instantiate --eval -A "$attrPath.version" | tr -d '"')
fi

if [[ $# -gt 0 ]]; then
  targetVersion="$1"
else
  targetVersion=$(
    git ls-remote --tags --refs --sort="v:refname" https://github.com/geph-official/geph5.git \
      | awk '{ print $2 }' \
      | sed -nE 's,^refs/tags/geph5-client-v([0-9]+\.[0-9]+\.[0-9]+)$,\1,p' \
      | tail -1
  )
fi

if [[ -z "${targetVersion:-}" ]]; then
  echo "Failed to find any geph5-client tags" >&2
  exit 1
fi

if [[ "$oldVersion" == "$targetVersion" ]]; then
  echo "geph is already up-to-date"
  exit 0
fi

(
  cd "$nixpkgs"
  update-source-version "$attrPath" "$targetVersion"
  update-source-version "$attrPath" --ignore-same-version --source-key=cargoDeps.vendorStaging
)
