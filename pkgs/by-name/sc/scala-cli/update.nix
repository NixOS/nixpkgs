{
  lib,
  curl,
  writeShellScript,
  jq,
  gnused,
  git,
  nix,
  coreutils,
}:
{
  platforms,
  pname,
  version,
}:

writeShellScript "${pname}-update-script" ''
  set -o errexit
  PATH=${
    lib.makeBinPath [
      curl
      jq
      gnused
      git
      nix
      coreutils
    ]
  }

  latest_version=$(curl -s "https://api.github.com/repos/VirtusLab/scala-cli/releases?per_page=1" | jq ".[0].tag_name" --raw-output | sed 's/^v//')

  if [[ "${version}" = "$latest_version" ]]; then
      echo "The new version same as the old version."
      exit 0
  fi

  nixpkgs=$(git rev-parse --show-toplevel)
  sources_json="$nixpkgs/pkgs/by-name/sc/scala-cli/sources.json"

  platform_assets=()

  for platform in ${lib.concatStringsSep " " platforms}; do
    asset=$(jq ".assets.\"$platform\".asset" --raw-output < $sources_json)
    release_asset_url="https://github.com/Virtuslab/scala-cli/releases/download/v$latest_version/$asset"

    asset_hash=$(nix-prefetch-url "$release_asset_url")

    asset_object=$(jq --compact-output --null-input \
      --arg asset "$asset" \
      --arg sha256 "$asset_hash" \
      --arg platform "$platform" \
      '{asset: $asset, sha256: $sha256, platform: $platform}')
    platform_assets+=($asset_object)
  done

  printf '%s\n' "''${platform_assets[@]}" | \
    jq -s "map ( { (.platform): . | del(.platform) }) | add" | \
    jq --arg version $latest_version \
      '{ version: $version, assets: . }' > $sources_json
''
