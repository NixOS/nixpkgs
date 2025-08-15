#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash cacert curl nix jq common-updater-scripts
set -euo pipefail

currentVersion=$(nix eval --raw -f . orb.version)

for i in \
  "x86_64-linux https://pkgs.orb.net/stable/ubuntu/dists/orb/main/binary-amd64/Packages" \
  "aarch64-linux https://pkgs.orb.net/stable/ubuntu/dists/orb/main/binary-arm64/Packages"
do
  set -- $i
  system=$1
  metadataUrl=$2

  metadata=$(curl -s $metadataUrl)
  version=$(echo "$metadata" | grep "^Version:" | head -n1 | cut -d' ' -f2)
  sha256Hash=$(echo "$metadata" | grep "^SHA256:" | head -n1 | cut -d' ' -f2)

  if [[ "$version" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
  fi

  sriHash=$(nix hash convert --hash-algo sha256 --to sri $sha256Hash)
  update-source-version orb $version $sriHash --system=$system --ignore-same-version
done
