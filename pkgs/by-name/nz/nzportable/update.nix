{
  lib,
  writeShellApplication,
  jq,
  curl,
  nix-prefetch-git,
  common-updater-scripts,
}:

lib.getExe (writeShellApplication {
  name = "nzp-updater";
  runtimeInputs = [
    jq
    curl
    nix-prefetch-git
    common-updater-scripts
  ];
  text = ''
    youngest=0
    update() {
      repo=$1
      tag=$2

      prefetch=$(nix-prefetch-git "https://github.com/nzp-team/$repo" --rev "$tag")

      timestamp=$(echo "$prefetch" | jq -r '.date | strptime("%Y-%m-%dT%H:%M:%S%z") | mktime | strftime("%Y-%m-%d-%H-%M-%S")')
      rev=$(echo "$prefetch" | jq -r ".rev")
      hash=$(echo "$prefetch" | jq -r ".hash")

      if [[ $youngest -lt $timestamp ]]; then
        youngest=$timestamp
      fi

      update-source-version "$UPDATE_NIX_ATTR_PATH.$repo" "0-unstable-$timestamp" "$hash" --rev="$rev"
    }

    update fteqw bleeding-edge
    update assets newest
    update quakec bleeding-edge
  '';
})
