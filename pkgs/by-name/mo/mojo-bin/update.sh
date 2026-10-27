#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

packageDir=$(dirname "$(readlink -f "$0")")

pypiJson() {
  curl --fail --silent --show-error "https://pypi.org/pypi/$1/$2/json"
}

wheel() {
  local package=$1
  local version=$2
  local filename=$3
  local metadata url digest hash

  metadata=$(pypiJson "$package" "$version")
  url=$(jq --exit-status --raw-output --arg filename "$filename" \
    '.urls[] | select(.filename == $filename) | .url' <<<"$metadata")
  digest=$(jq --exit-status --raw-output --arg filename "$filename" \
    '.urls[] | select(.filename == $filename) | .digests.sha256' <<<"$metadata")
  hash=$(nix hash convert --hash-algo sha256 --to sri "$digest")

  jq --null-input --compact-output --arg url "$url" --arg hash "$hash" \
    '{ $url, $hash }'
}

version=$(curl --fail --silent --show-error https://pypi.org/pypi/mojo/json | jq -er .info.version)
mojoMetadata=$(pypiJson mojo "$version")
mblackVersion=$(jq --exit-status --raw-output \
  '.info.requires_dist[] | select(startswith("mblack==")) | sub("^mblack=="; "")' \
  <<<"$mojoMetadata")

maxCoreMetadata=$(curl --fail --silent --show-error https://pypi.org/pypi/max-core/json)
maxVersion=$(jq --exit-status --raw-output '.info.version' <<<"$maxCoreMetadata")
requiredMojoCompilerVersion=$(jq --exit-status --raw-output \
  '.info.requires_dist[] | select(startswith("mojo-compiler==")) | sub("^mojo-compiler=="; "")' \
  <<<"$maxCoreMetadata")
if [[ $requiredMojoCompilerVersion != "$version" ]]; then
  echo "max-core $maxVersion requires mojo-compiler $requiredMojoCompilerVersion, not $version" >&2
  exit 1
fi

mojoCompilerMojoLibs=$(wheel mojo-compiler-mojo-libs "$version" \
  "mojo_compiler_mojo_libs-$version-py3-none-any.whl")
maxMojoLibs=$(wheel max-mojo-libs "$maxVersion" \
  "max_mojo_libs-$maxVersion-py3-none-any.whl")
mblack=$(wheel mblack "$mblackVersion" "mblack-$mblackVersion-py3-none-any.whl")

for systemAndWheelTag in \
  x86_64-linux:manylinux_2_34_x86_64 \
  aarch64-linux:manylinux_2_34_aarch64 \
  aarch64-darwin:macosx_13_0_arm64
do
  system=${systemAndWheelTag%%:*}
  wheelTag=${systemAndWheelTag#*:}
  maxCore=$(wheel max-core "$maxVersion" \
    "max_core-$maxVersion-py3-none-$wheelTag.whl")
  mojo=$(wheel mojo "$version" \
    "mojo-$version-py3-none-$wheelTag.whl")
  mojoCompiler=$(wheel mojo-compiler "$version" \
    "mojo_compiler-$version-py3-none-$wheelTag.whl")
  mojoLldbLibs=$(wheel mojo-lldb-libs "$version" \
    "mojo_lldb_libs-$version-py3-none-$wheelTag.whl")
  systemJson=$(jq --null-input --compact-output \
    --argjson maxCore "$maxCore" \
    --argjson mojo "$mojo" \
    --argjson mojoCompiler "$mojoCompiler" \
    --argjson mojoLldbLibs "$mojoLldbLibs" \
    '{ $maxCore, $mojo, $mojoCompiler, $mojoLldbLibs }')

  case "$system" in
    x86_64-linux)
      x86_64Linux=$systemJson
      ;;
    aarch64-linux)
      aarch64Linux=$systemJson
      ;;
    aarch64-darwin)
      aarch64Darwin=$systemJson
      ;;
  esac
done

jq --null-input \
  --arg version "$version" \
  --arg mblackVersion "$mblackVersion" \
  --arg maxVersion "$maxVersion" \
  --argjson maxMojoLibs "$maxMojoLibs" \
  --argjson mojoCompilerMojoLibs "$mojoCompilerMojoLibs" \
  --argjson mblack "$mblack" \
  --argjson x86_64Linux "$x86_64Linux" \
  --argjson aarch64Linux "$aarch64Linux" \
  --argjson aarch64Darwin "$aarch64Darwin" \
  '{
    $version,
    $mblackVersion,
    $maxVersion,
    common: { $maxMojoLibs, $mojoCompilerMojoLibs, $mblack },
    systems: {
      "x86_64-linux": $x86_64Linux,
      "aarch64-linux": $aarch64Linux,
      "aarch64-darwin": $aarch64Darwin
    }
  }' > "$packageDir/sources.json"
