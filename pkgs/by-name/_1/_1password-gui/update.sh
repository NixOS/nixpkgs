#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq curl gawk
#shellcheck shell=bash
set -euo pipefail

# For Linux version checks we query upstream's APT repository.
#
# Repository only offers amd64 packages for the desktop app.
# We assume updates are always for both architectures.
OP_APT_REPO_DIST_BASE="https://downloads.1password.com/linux/debian/amd64/dists"
OP_APT_REPO_COMPONENT_INDEX="main/binary-amd64/Packages"

# For Darwin version checks we query the same endpoint 1Password 8 for Mac queries.
# This is the base URI. For stable channel an additional path of "N", for beta channel, "Y" is required.
APP_UPDATES_URI_BASE="https://app-updates.agilebits.com/check/2/99/aarch64/OPM8/en/0/A1"

CURL=(
  "curl" "--silent" "--show-error" "--fail"
  "--proto" "=https" # enforce https
  "--tlsv1.2" # do not accept anything below tls 1.2
  "-H" "user-agent: nixpkgs#_1password-gui update.sh" # repology requires a descriptive user-agent
)

JQ=("jq" "--raw-output")


read_local_versions() {
  local channel="$1"

  while IFS='=' read -r key value; do
    local_versions["${key}"]="${value}"
  done < <(jq -r --arg channel "${channel}" '
    .[$channel] | to_entries[] | .key as $os | .value.version as $version |
    "\($channel)/\($os)=\($version)"
  ' sources.json)
}

read_remote_versions() {
  local channel="$1"
  local apt_index="${OP_APT_REPO_DIST_BASE}/${channel}/${OP_APT_REPO_COMPONENT_INDEX}"
  local apt_awk_prog=$'
    /^Package: 1password$/ { pkg_is_1password_gui=1 }
    /^Version/ && pkg_is_1password_gui { print $2; exit }
  '
  local chan_os ver

  if [[ ${channel} == "stable" ]]; then
    chan_os="${channel}/linux"
    ver=$("${CURL[@]}" "${apt_index}" | awk "${apt_awk_prog}")
    if [[ -n ${ver} ]]; then
      remote_versions["${chan_os}"]="${ver}"
    else
      echo "No remote version for ${chan_os}" >&2
    fi

    chan_os="${channel}/darwin"
    ver=$(
      "${CURL[@]}" "${APP_UPDATES_URI_BASE}/N" \
        | "${JQ[@]}" 'select(.available == "1") | .version'
    )
    if [[ -n ${ver} ]]; then
      remote_versions["${chan_os}"]="${ver}"
    else
      echo "No remote version for ${chan_os}" >&2
    fi
  else
    chan_os="${channel}/linux"
    ver=$(
      # Deb package version string uses tilde instead of dashes for betas.
      "${CURL[@]}" "${apt_index}" | awk "${apt_awk_prog}" | sed 's/~/-/'
    )
    if [[ -n ${ver} ]]; then
      remote_versions["${chan_os}"]="${ver}"
    else
      echo "No remote version for ${chan_os}" >&2
    fi

    # Handle macOS Beta app-update feed quirk.
    # If there is a newer release in the stable channel, queries for beta
    # channel will return the stable channel version; masking the current beta.
    chan_os="${channel}/darwin"
    ver=$(
      "${CURL[@]}" "${APP_UPDATES_URI_BASE}/Y" \
        | "${JQ[@]}" 'select(.available == "1" and (.version | endswith(".BETA"))) | .version'
    )
    if [[ -n ${ver} ]]; then
      remote_versions["${chan_os}"]="${ver}"
    else
      echo "No remote version for ${chan_os}" >&2
    fi
  fi
}

render_versions_json() {
  local key value

  for key in "${!local_versions[@]}"; do
    value="${local_versions[${key}]}"
    echo "${key}"
    echo "${value}"
  done \
    | jq -nR 'reduce inputs as $i ({}; . + { $i: input })'
}


cd -- "$(dirname "${BASH_SOURCE[0]}")"

attr_path=${UPDATE_NIX_ATTR_PATH}
case "${attr_path}" in
  _1password-gui) channel="stable" ;;
  _1password-gui-beta) channel="beta" ;;
  *)
    echo "Unknown attribute path ${attr_path}" >&2
    exit 1
esac

declare -A local_versions remote_versions
declare -a new_version_available=()
read_local_versions "${channel}"
read_remote_versions "${channel}"
for i in "${!remote_versions[@]}"; do
  if [[ "${local_versions[$i]}" != "${remote_versions[$i]}" ]]; then
    old_version="${local_versions[$i]}"
    new_version="${remote_versions[$i]}"
    new_version_available+=("$i/$new_version")
  fi
done

num_updates=${#new_version_available[@]}
if (( num_updates == 0 )); then
  exit # up to date
elif (( num_updates == 1 )); then
  os=$(cut -d / -f 2 <<<"${new_version_available[@]}")
  os_specific_update=" (${os} only)"
fi

./update-sources.py "${new_version_available[@]}"
cat <<EOF
[
  {
    "attrPath": "${attr_path}",
    "oldVersion": "${old_version}",
    "newVersion": "${new_version}${os_specific_update-}",
    "files": [
      "$PWD/sources.json"
    ]
  }
]
EOF
