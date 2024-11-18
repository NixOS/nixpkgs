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
      attr=$1; shift
      repo=$1; shift
      tag=$1; shift

      prefetch=$(nix-prefetch-git "https://github.com/nzp-team/$repo" --rev "$tag")

      timestamp=$(echo "$prefetch" | jq -r '.date | strptime("%Y-%m-%dT%H:%M:%S%z") | mktime | strftime("%Y-%m-%d-%H-%M-%S")')
      rev=$(echo "$prefetch" | jq -r ".rev")
      hash=$(echo "$prefetch" | jq -r ".hash")

      if [[ $youngest -lt $timestamp ]]; then
        youngest=$timestamp
      fi

      update-source-version "$attr" "0-unstable-$timestamp" "$hash" --rev="$rev" "$@"
    }

    update nzportable fteqw bleeding-edge --version-key=fteqwVersion
    update nzportable-assets assets newest
    update nzportable-quakec quakec bleeding-edge
  '';
})
