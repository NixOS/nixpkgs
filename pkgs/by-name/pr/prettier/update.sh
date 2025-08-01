#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts coreutils jq yarn-berry.yarn-berry-fetcher

set -o errexit -o nounset -o pipefail
set -o xtrace # debugging

# Configuration
owner='prettier'
repo='prettier'
package='prettier'

cleanup() {
  rm --force --recursive "${tmpdir}"
}
trap cleanup EXIT
tmpdir="$(mktemp --directory)"

disable_cleanup() {
  # We want to keep the temporary directory in case of error
  trap - EXIT
}
trap disable_cleanup ERR

curl_command=(curl --fail ${GITHUB_TOKEN:+--user ":${GITHUB_TOKEN}"})
jq_command=(jq --raw-output)

current_version=$(nix-instantiate --eval --expr "with import ./. {}; ${package}.version or (lib.getVersion ${package})" --raw)
echo "Current version: ${current_version}"

latest_version="$("${curl_command[@]}" "https://api.github.com/repos/${owner}/${repo}/releases/latest" | "${jq_command[@]}" .tag_name)"
echo "Latest version: ${latest_version}"

if [[ "${current_version}" == "${latest_version}" ]]; then
  echo "${package} is up to date: ${current_version}"
  exit 0
else
  echo "Updating ${package} from ${current_version} to ${latest_version}…"
fi

package_dir="pkgs/by-name/${package::2}/${package}"
"${curl_command[@]}" --output "${package_dir}/package.json" "https://raw.githubusercontent.com/${owner}/${repo}/${latest_version}/package.json"

update-source-version "${package}" "${latest_version}"

echo "Update yarn offline cache hash…"
nix-build --attr "${package}.src"
yarn-berry-fetcher missing-hashes result/yarn.lock >"${package_dir}/missing-hashes.json"
