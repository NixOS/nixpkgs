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
  pname,
  owner,
  repo,
  tagPrefix,
  sourcesJson,
  platforms,
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

  nixpkgs=$(git rev-parse --show-toplevel)
  sources_json="$nixpkgs/${sourcesJson}"
  if [[ ! -f "$sources_json" ]]; then
    echo "buildGithubBinary update: $sources_json not found (run from inside the nixpkgs checkout)" >&2
    exit 1
  fi

  old_version=$(jq --raw-output ".version" < "$sources_json")
  latest_version=$(curl -s "https://api.github.com/repos/${owner}/${repo}/releases?per_page=1" \
    | jq --raw-output ".[0].tag_name" \
    | sed 's/^${tagPrefix}//')

  if [[ "$old_version" = "$latest_version" ]]; then
      echo "${pname} is already at the latest version $latest_version."
      exit 0
  fi

  platform_assets=()

  for platform in ${lib.concatStringsSep " " platforms}; do
    old_asset=$(jq --raw-output ".assets.\"$platform\".asset" < "$sources_json")
    new_asset=''${old_asset//$old_version/$latest_version}
    release_asset_url="https://github.com/${owner}/${repo}/releases/download/${tagPrefix}$latest_version/$new_asset"

    asset_hash=$(nix-prefetch-url "$release_asset_url")

    asset_object=$(jq --compact-output --null-input \
      --arg asset "$new_asset" \
      --arg sha256 "$asset_hash" \
      --arg platform "$platform" \
      '{asset: $asset, sha256: $sha256, platform: $platform}')
    platform_assets+=("$asset_object")
  done

  printf '%s\n' "''${platform_assets[@]}" \
    | jq -s "map ( { (.platform): . | del(.platform) }) | add" \
    | jq --arg version "$latest_version" \
        '{ version: $version, assets: . }' > "$sources_json"
''
