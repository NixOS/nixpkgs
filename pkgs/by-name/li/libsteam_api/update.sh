#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-git

set -euo pipefail

attr() {
  nix-instantiate --eval --raw --attr "libsteam_api.$1"
}

githubMirror="UlyssesZh/steamworks-sdk"

tag="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/$githubMirror/tags \
  | jq -r 'map(.name)[]' | sort -V | tail -n 1)"

version="${tag#v}"
oldVersion="$(attr version)"
if [[ "$version" == "$oldVersion" ]]; then
  echo "Already up to date ($version)" >&2
  exit 0
fi

nixFile="$(attr meta.position | cut -d : -f 1)"
sed -i -E "s|version = \"[^\"]\";|version = \"$version\";|" "$nixFile"

hash="$(nix-prefetch-git "https://github.com/$githubMirror.git" "$tag" --name "$(attr src.name)" | jq -r .hash)"
sed -i -E "s|hash = \"[^\"]\";|hash = \"$hash\";|" "$nixFile"
