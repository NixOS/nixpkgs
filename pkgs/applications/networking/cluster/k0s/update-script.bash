#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils go gh nix-prefetch

set -euo pipefail

list_k0s_releases() {
  #shellcheck disable=SC2016
  local query='.[] | select(.prerelease == false and .draft == false) | .tag_name | select(startswith($ENV.VERSION_PREFIX))'
  VERSION_PREFIX="v$1" gh api -X GET /repos/k0sproject/k0s/releases -F per_page=100 --paginate --jq "$query"
}

k0s_sort() {
  go run github.com/k0sproject/version/cmd/k0s_sort@v0.6.0
}

latest_release() {
  list_k0s_releases "$1" | k0s_sort | tail -1
}

hash_file() {
  local sha256
  sha256=$(nix-prefetch-url --quiet "$1")
  nix hash to-sri --type sha256 "$sha256"
}

main() {
  k0sMajorMinor=$(echo "$UPDATE_NIX_OLD_VERSION" | cut -d . -f1,2)
  [ -n "$k0sMajorMinor" ] || {
    echo Failed to determine k0s minor version >&2
    exit 1
  }

  latestRelease=$(latest_release "$k0sMajorMinor")
  latestRelease=${latestRelease#v}
  [ -n "$latestRelease" ] || {
    echo Failed to find latest k0s release >&2
    exit 1
  }

  [ "$latestRelease" != "$UPDATE_NIX_OLD_VERSION" ] || {
    # already up to date
    exit 0
  }

  local -A archs
  archs['x86_64-linux']=amd64
  archs['aarch64-linux']=arm64
  archs['armv7l-linux']=arm

  local -A urls hashes
  for arch in "${archs[@]}"; do
    urls[$arch]="https://github.com/k0sproject/k0s/releases/download/v$latestRelease/k0s-v$latestRelease-$arch"
    hashes[$arch]=$(hash_file "${urls[$arch]}")
  done

  packagePath=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
  outFile="$packagePath/${k0sMajorMinor/./_}.nix"

  {
    cat <<EOF
{
  version = "$latestRelease";
  srcs = {
EOF
    for arch in "${!archs[@]}"; do
      cat <<EOF
    $arch = {
      url = "${urls[${archs[$arch]}]}";
      hash = "${hashes[${archs[$arch]}]}";
    };
EOF
    done
    cat <<EOF
  };
}
EOF

  } >"$outFile"

  cat <<EOF
[{
  "attrPath": "$UPDATE_NIX_ATTR_PATH",
  "oldVersion": "$UPDATE_NIX_OLD_VERSION",
  "newVersion": "$latestRelease",
  "files": [ "$outFile" ]
}]
EOF
}

main
