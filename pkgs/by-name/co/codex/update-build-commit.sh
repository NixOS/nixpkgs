#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused
# shellcheck shell=bash

set -eu -o pipefail

package_dir=$(dirname "$(readlink --canonicalize-existing "${BASH_SOURCE[0]}")")
package_file="$package_dir/package.nix"
release=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --fail --location \
  "https://api.github.com/repos/openai/codex/releases/latest")
tag=$(jq --exit-status --raw-output '.tag_name' <<<"$release")
commit=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --fail --location \
  "https://api.github.com/repos/openai/codex/commits/$tag" \
  | jq --exit-status --raw-output '.sha')

sed --in-place --regexp-extended \
  "s|buildCommit = \"[0-9a-f]{40}\";|buildCommit = \"$commit\";|" \
  "$package_file"
