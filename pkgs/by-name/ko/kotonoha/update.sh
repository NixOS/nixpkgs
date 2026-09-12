#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils curl jq nix
# shellcheck shell=bash

set -euo pipefail

readonly owner="locez"
readonly repo="kotonoha"
package_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly package_dir
readonly hashes_file="${package_dir}/hashes.json"

current_version="$(jq --raw-output '.version' "${hashes_file}")"
latest_tag="$(curl --fail --silent --show-error --location \
  -H 'Accept: application/vnd.github+json' \
  "https://api.github.com/repos/${owner}/${repo}/releases/latest" |
  jq --exit-status --raw-output '.tag_name | select(type == "string" and length > 0)')"
latest_version="${latest_tag#v}"

latest_version_ordered="$(printf '%s\n' "${current_version}" "${latest_version}" | sort --version-sort | tail --lines=1)"
if [[ "${latest_version}" == "${current_version}" || "${latest_version_ordered}" != "${latest_version}" ]]; then
  echo "Already up to date (${current_version})"
  exit 0
fi

source_hash="$(nix-prefetch-url --unpack \
  "https://github.com/${owner}/${repo}/archive/refs/tags/${latest_tag}.tar.gz")"
source_hash="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "${source_hash}")"

temporary_file="$(mktemp "${hashes_file}.XXXXXX")"
trap 'rm --force "${temporary_file}"' EXIT
jq --arg version "${latest_version}" --arg hash "${source_hash}" \
  '.version = $version | .hash = $hash' "${hashes_file}" >"${temporary_file}"
chmod 644 "${temporary_file}"
mv "${temporary_file}" "${hashes_file}"

echo "Updated ${repo} from ${current_version} to ${latest_version}"
