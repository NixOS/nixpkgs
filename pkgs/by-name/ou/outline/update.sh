#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl git gnused jq nix-prefetch-github yarn-berry.yarn-berry-fetcher

set -o errexit -o nounset -o pipefail

package="outline"
owner="outline"
repo="outline"
package_dir="pkgs/by-name/${package::2}/${package}"

#
# package
#

current_version=$(nix-instantiate --eval --expr "with import ./. {}; ${package}.version" --raw)
echo "Current version: ${current_version}"

latest_version=$(curl --silent "https://api.github.com/repos/${owner}/${repo}/releases" | jq '.[0].tag_name' --raw-output | sed 's/^v//')
echo "Latest version: ${latest_version}"

if [[ "${current_version}" == "${latest_version}" ]]; then
  echo "${package} is up to date: ${current_version}"
  exit 0
fi

echo "Updating ${package} from ${current_version} to ${latest_version}…"

update-source-version "${package}" "${latest_version}"

#
# yarn deps
#

echo "Regenerating missing-hashes.json…"
src_path=$(nix-build --attr "${package}.src" --no-link)
yarn-berry-fetcher missing-hashes "${src_path}/yarn.lock" >"${package_dir}/missing-hashes.json"

echo "Updating offline cache hash…"
update-source-version "${package}" --ignore-same-version --source-key=offlineCache

echo "Done."
