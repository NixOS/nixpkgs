#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nixfmt-rfc-style common-updater-scripts
set -eEuo pipefail
[ -z "${DEBUG:-}" ] || set -x
cd "${BASH_SOURCE[0]%/*}"
# run: nix-shell maintainers/scripts/update.nix --argstr package msgraph-cli

package_file="./package.nix"

pname="$(sed -nE 's/\s*pname = "(.*)".*/\1/p' "${package_file}")"
owner="$(sed -nE 's/\s*owner = "(.*)".*/\1/p' "${package_file}")"
repo="$(sed -nE 's/\s*repo = "(.*)".*/\1/p' "${package_file}")"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' "${package_file}")"

new_version="$(curl -s "https://api.github.com/repos/${owner}/${repo}/releases?per_page=1" | jq -r '.[0].name' | sed 's|^GCM ||')"
if [[ $new_version == "$old_version" ]]; then
  echo "Up to date"
  exit 0
fi

cd ../../../..
update-source-version "${repo}" "$new_version"
"$(nix-build -A "${pname}.fetch-deps" --no-out-link)"
