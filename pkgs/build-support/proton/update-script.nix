{
  lib,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

{ latestVersionCommand }:

writeShellScript "proton-bin-update-script" ''
  set -euo pipefail
  export PATH=${
    lib.makeBinPath [
      curl
      jq
      common-updater-scripts
    ]
  }:$PATH

  attr="''${UPDATE_NIX_ATTR_PATH:?run this through maintainers/scripts/update.nix}"
  oldVersion="''${UPDATE_NIX_OLD_VERSION:?run this through maintainers/scripts/update.nix}"

  version="$(${latestVersionCommand})"
  if [[ -z "$version" || "$version" == null ]]; then
    echo "$attr: could not determine the latest version" >&2
    exit 1
  fi
  if [[ "$version" == "$oldVersion" ]]; then
    echo "$attr: already at the latest version $version" >&2
    exit 0
  fi

  for system in $(nix-instantiate --eval --json -A "$attr.meta.platforms" | jq -r '.[]'); do
    case "$system" in
      x86_64-linux) crossAttr=gnu64 ;;
      aarch64-linux) crossAttr=aarch64-multiplatform ;;
      *)
        echo "$attr: don't know how to update the src for $system" >&2
        exit 1
        ;;
    esac
    update-source-version "pkgsCross.$crossAttr.$attr" "$version" --ignore-same-version
  done
''
