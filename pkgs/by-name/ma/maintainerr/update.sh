#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl jq yarn-berry_4.yarn-berry-fetcher

set -o errexit -o nounset -o pipefail

package="maintainerr"
owner="Maintainerr"
repo="Maintainerr"
package_dir="$(dirname "${BASH_SOURCE[0]}")"

current_version=$(nix-instantiate --eval --expr "with import ./. {}; ${package}.version" --raw)
echo "Current version: ${current_version}"

latest_version=$(curl --fail --silent ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
  "https://api.github.com/repos/${owner}/${repo}/releases/latest" | jq --raw-output '.tag_name | ltrimstr("v")')
echo "Latest version: ${latest_version}"

if [[ "${current_version}" == "${latest_version}" ]]; then
  echo "${package} is up to date: ${current_version}"
  exit 0
fi

echo "Updating ${package} from ${current_version} to ${latest_version}…"

update-source-version "${package}" "${latest_version}"

echo "Regenerating missing-hashes.json…"
src_path=$(nix-build --attr "${package}.src" --no-link)
yarn-berry-fetcher missing-hashes "${src_path}/yarn.lock" >"${package_dir}/missing-hashes.json"

echo "Updating offline cache hash…"
update-source-version "${package}" --ignore-same-version --source-key=offlineCache

echo "Done."
