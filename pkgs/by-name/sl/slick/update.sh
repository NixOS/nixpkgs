#!/usr/bin/env nix-shell
#! nix-shell -i bash -p cacert curl jq nix nix-update

set -euo pipefail

package_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
curl_args=(-sfL ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"})

tag=$(curl "${curl_args[@]}" https://api.github.com/repos/3kh0/slick/releases/latest | jq -r .tag_name)

electron_major=$(
  curl "${curl_args[@]}" "https://raw.githubusercontent.com/3kh0/slick/$tag/package.json" |
    jq -r .devDependencies.electron | tr -d '^~' | cut -d. -f1
)

if [[ $(nix-instantiate --eval --expr "(import ./. { }) ? electron_$electron_major") != true ]]; then
  echo "slick $tag needs electron_$electron_major, which is not in nixpkgs yet" >&2
  exit 1
fi

sed -i -E "s/electron_[0-9]+/electron_$electron_major/g" "$package_dir/package.nix"

nix-update slick --version "2.0.${tag#v}" --subpackage node-modules
