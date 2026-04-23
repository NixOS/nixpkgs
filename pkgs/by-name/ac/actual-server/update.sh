#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils git jq nix-prefetch-github yarn-berry.yarn-berry-fetcher

set -o errexit -o nounset -o pipefail

package="actual-server"
owner="actualbudget"
repo="actual"
translations_repo="translations"
package_dir="pkgs/by-name/${package::2}/${package}"

#
# package
#

current_version=$(nix-instantiate --eval --expr "with import ./. {}; ${package}.version" --raw)
echo "Current version: ${current_version}"

latest_version=$(list-git-tags --url="https://github.com/${owner}/${repo}" | grep -oP '^v\K[0-9.]+$' | sort --version-sort | tail --lines=1)
echo "Latest version: ${latest_version}"

if [[ "${current_version}" == "${latest_version}" ]]; then
  echo "${package} is up to date: ${current_version}"
  exit 0
fi

echo "Updating ${package} from ${current_version} to ${latest_version}…"

update-source-version "${package}" "${latest_version}"

#
# translations
#

echo "Updating translations repo"
old_translations_rev=$(nix-instantiate --eval --expr "with import ./. {}; ${package}.translations.rev" --raw)
old_translations_hash=$(nix-instantiate --eval --expr "with import ./. {}; ${package}.translations.outputHash" --raw)

translations_rev=$(git ls-remote "https://github.com/${owner}/${translations_repo}" HEAD | cut -f1)
echo "Latest translations rev: ${translations_rev}"

translations_hash=$(nix-prefetch-github --json --rev "${translations_rev}" "${owner}" "${translations_repo}" | jq --raw-output .hash)
echo "Translations hash: ${translations_hash}"

sed -i "s|${old_translations_rev}|${translations_rev}|" "${package_dir}/package.nix"
sed -i "s|${old_translations_hash}|${translations_hash}|" "${package_dir}/package.nix"

#
# yarn deps
#

echo "Regenerating missing-hashes.json…"
src_path=$(nix-build --attr "${package}.src" --no-link)
yarn-berry-fetcher missing-hashes "${src_path}/yarn.lock" >"${package_dir}/missing-hashes.json"

echo "Updating offline cache hash…"
update-source-version "${package}" --ignore-same-version --source-key=offlineCache

echo "Done."
