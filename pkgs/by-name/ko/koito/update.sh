#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix coreutils nix-update yarn-berry_4.yarn-berry-fetcher

set -euo pipefail

owner="gabehf"
repo="koito"
package_dir="$(realpath "$(dirname "$0")")"

latest_tag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com/repos/${owner}/${repo}/releases/latest" | jq -r .tag_name)
latest_version="${latest_tag#v}"

if [[ "${UPDATE_NIX_OLD_VERSION}" == "${latest_version}" ]]; then
  echo "koito is up to date: ${UPDATE_NIX_OLD_VERSION}"
  exit 0
fi

echo "Updating koito from ${UPDATE_NIX_OLD_VERSION} to ${latest_version}…"

nix-update koito --version "${latest_version}"

src_path=$(nix-build --no-out-link -A koito.src)

echo "Regenerating missing-hashes.json…"
yarn-berry-fetcher missing-hashes "${src_path}/client/yarn.lock" >"${package_dir}/missing-hashes.json"

echo "Updating offline cache hash…"
offline_cache_hash=$(yarn-berry-fetcher prefetch "${src_path}/client/yarn.lock" "${package_dir}/missing-hashes.json")
old_hash=$(nix-instantiate --eval --expr "with import ./. {}; koito.client.offlineCache.outputHash" --raw)
sed -i "s|${old_hash}|${offline_cache_hash}|" "${package_dir}/client.nix"

echo "Done."
