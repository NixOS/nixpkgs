#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix
# shellcheck shell=bash

set \
  -o errexit \
  -o pipefail \
  -o nounset \
  -o errtrace

shopt -s \
  inherit_errexit \
  shift_verbose

curl_args=(
  --fail
  --location
  --silent
  --show-error
)

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  curl_args+=(--user ":${GITHUB_TOKEN}")
fi

release="$(
  curl \
    "${curl_args[@]}" \
    https://api.github.com/repos/aptakube/aptakube/releases/latest
)"
version="$(
  jq \
    --exit-status \
    --raw-output \
    '.tag_name | select(type == "string")' \
    <<<"${release}"
)"

get_hash() {
  local name="$1"
  local digest

  digest="$(
    jq \
      --arg name "${name}" \
      --exit-status \
      --raw-output \
      '.assets[] | select(.name == $name) | .digest | select(type == "string" and startswith("sha256:"))' \
      <<<"${release}"
  )"

  nix hash convert \
    --hash-algo sha256 \
    --to sri \
    "${digest#sha256:}"
}

get_url() {
  local system="$1"

  nix-instantiate \
    --argstr system "${system}" \
    --argstr version "${version}" \
    --eval \
    --expr '
      { system, version }:
      let
        package = (import ./. { inherit system; }).aptakube.overrideAttrs (_: {
          inherit version;
          __intentionallyOverridingVersion = true;
        });
      in
      package.src.url
    ' \
    --raw
}

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../.."
printf 'Updating aptakube to %s\n' "${version}"

platforms="$(
  nix-instantiate \
    --eval \
    --json \
    --strict \
    --attr aptakube.meta.platforms
)"
systems="$(
  jq \
    --exit-status \
    --raw-output \
    '.[] | select(type == "string")' \
    <<<"${platforms}"
)"

while IFS= read -r system; do
  url="$(get_url "${system}")"
  name="${url##*/}"
  hash="$(get_hash "${name}")"

  update-source-version \
    aptakube \
    "${version}" \
    "${hash}" \
    --ignore-same-hash \
    --ignore-same-version \
    --system="${system}"
done <<<"${systems}"
