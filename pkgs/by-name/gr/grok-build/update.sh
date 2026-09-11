#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

version="$(curl -fsSL https://x.ai/cli/stable)"

currentVersion=$(
  nix-instantiate --eval --raw -E "with import ./. {}; grok-build.version or (lib.getVersion grok-build)"
)

if [[ "$currentVersion" == "$version" ]]; then
  echo "package is up-to-date: $version"
  exit 0
fi

update-source-version grok-build "${version}" || true

for system in "aarch64-darwin macos-aarch64" "aarch64-linux linux-aarch64" "x86_64-linux linux-x86_64"; do
  # shellcheck disable=SC2086
  set -- ${system}

  arch="${1}"
  platform="${2}"

  url="https://x.ai/cli/grok-${version}-${platform}"
  hash=$(
    nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$(
      nix-prefetch-url "${url}"
    )"
  )

  update-source-version grok-build "${version}" "${hash}" --system="${arch}" --ignore-same-version
done
