#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils curl git gnused jq nix

set -euo pipefail

readonly owner="locez"
readonly repo="bilihud"
readonly package_path="pkgs/by-name/bi/bilihud"
readonly dummy_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

readonly nixpkgs_root="$(git rev-parse --show-toplevel)"
readonly hashes_file="${nixpkgs_root}/${package_path}/hashes.json"

cd "${nixpkgs_root}"

current_version="$(jq --raw-output '.version' "${hashes_file}")"
latest_version="$({
  curl --fail --silent --show-error --location \
    -H 'Accept: application/vnd.github+json' \
    "https://api.github.com/repos/${owner}/${repo}/releases/latest"
} | jq --raw-output '.tag_name | ltrimstr("v")')"

if [[ -z "${latest_version}" || "${latest_version}" == "null" ]]; then
  echo "Could not determine the latest ${repo} release" >&2
  exit 1
fi

latest_version_ordered="$(printf '%s\n' "${current_version}" "${latest_version}" | sort --version-sort | tail --lines=1)"
if [[ "${latest_version}" == "${current_version}" || "${latest_version_ordered}" != "${latest_version}" ]]; then
  echo "Already up to date (${current_version})"
  exit 0
fi

temporary_backup="$(mktemp)"
cp "${hashes_file}" "${temporary_backup}"
cleanup() {
  local status=$?

  if [[ ${status} -ne 0 ]]; then
    cp "${temporary_backup}" "${hashes_file}"
  fi

  rm --force "${temporary_backup}"
}
trap cleanup EXIT

update_hashes_file() {
  local key="$1"
  local value="$2"
  local temporary_file

  temporary_file="$(mktemp)"
  jq --arg key "${key}" --arg value "${value}" '.[$key] = $value' "${hashes_file}" >"${temporary_file}"
  mv "${temporary_file}" "${hashes_file}"
}

update_hashes_file version "${latest_version}"
update_hashes_file hash "${dummy_hash}"

output=""
status=0
if output="$(nix --extra-experimental-features 'nix-command flakes' build \
  --no-link \
  --log-format bar-with-logs \
  .#bilihud.src 2>&1)"; then
  status=0
else
  status=$?
fi

source_hash="$(printf '%s\n' "${output}" | sed --quiet --regexp-extended \
  's/.*got:[[:space:]]*(sha256-[A-Za-z0-9+/=]+).*/\1/p' | tail --lines=1)"

if [[ ${status} -eq 0 || -z "${source_hash}" ]]; then
  printf '%s\n' "${output}" >&2
  echo "Could not determine the source hash for ${repo}" >&2
  exit 1
fi

update_hashes_file hash "${source_hash}"

echo "Updated ${repo} from ${current_version} to ${latest_version}"
