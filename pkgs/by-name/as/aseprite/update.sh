#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix nix-update

set -euo pipefail

curl_github() {
  curl -fsSL -H 'Accept: application/vnd.github+json' ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} "$@"
}

nix-update aseprite

version=$(nix eval --raw --file . aseprite.version)
release_date=$(
  curl_github "https://api.github.com/repos/aseprite/aseprite/releases/tags/v$version" \
  | jq --exit-status --raw-output '.published_at'
)

strings_rev=$(
  curl_github "https://api.github.com/repos/aseprite/strings/commits?until=$release_date&per_page=1" \
  | jq --exit-status --raw-output '.[0].sha'
)

current_strings_rev=$(nix eval --raw --file . aseprite.asepriteStrings.rev)
if [[ $strings_rev != "$current_strings_rev" ]]; then
  update-source-version aseprite \
    --source-key=asepriteStrings \
    --rev="$strings_rev" \
    --ignore-same-version
fi
