#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq gnupg
#shellcheck shell=bash

set -euo pipefail

cd -- "$(dirname "${BASH_SOURCE[0]}")"

mk_url() {
  local \
    base_url="https://downloads.1password.com" \
    os="$1" \
    channel="$2" \
    arch="$3" \
    version="$4"

  if [[ ${os} == "linux" ]]; then
    if [[ ${arch} == "x86_64" ]]; then
      ext="x64.tar.gz"
    else
      ext="arm64.tar.gz"
    fi
    url="${base_url}/${os}/tar/${channel}/${arch}/1password-${version}.${ext}"
  else
    ext="${arch}.zip"
    url="${base_url}/mac/1Password-${version}-${ext}"
  fi

  echo "${url}"
}

cleanup() {
  if [[ -f ${GPG_KEYRING-} ]]; then
    rm "${GPG_KEYRING}"
  fi

  if [[ -f ${JSON_HEAP-} ]]; then
    rm "${JSON_HEAP}"
  fi
}

trap cleanup EXIT

# Get channel versions from versions.json
declare -A version=(
  ["stable"]=$(jq -r '.stable.version' versions.json)
  ["beta"]=$(jq -r '.beta.version' versions.json)
)

#
GPG_KEYRING=$(mktemp -t 1password.kbx.XXXXXX)
gpg --no-default-keyring --keyring "${GPG_KEYRING}" \
  --keyserver keyserver.ubuntu.com \
  --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22

JSON_HEAP=$(mktemp -t 1password-gui.jsonheap.XXXXXX)
for channel in stable beta; do
  for os in linux darwin; do
    for arch in x86_64 aarch64; do
      url=$(mk_url ${os} ${channel} ${arch} "${version[${channel}]}")
      nix store prefetch-file --json "${url}" | jq "
        {
          \"${channel}\": {
             \"${arch}-${os}\": {
               \"url\": \"${url}\",
               \"hash\": .hash,
               \"storePath\": .storePath
             }
           }
        }" >> "${JSON_HEAP}"

      # For some reason 1Password PGP signs only Linux binaries.
      if [[ ${os} == "linux" ]]; then
         gpgv --keyring "${GPG_KEYRING}" \
           $(nix store prefetch-file --json "${url}.sig" | jq -r .storePath) \
           $(jq -r --slurp ".[-1].[].[].storePath" "${JSON_HEAP}")
      fi
    done
  done
done

# Combine heap of hash+url objects into a single JSON object.
jq --slurp 'reduce .[] as $x ({}; . * $x) | del (.[].[].storePath)' "${JSON_HEAP}" > sources.json
