{
  version,
  lib,
  nix-update,
  elm2nix,
  nixfmt,
  writeShellScript,
  jq,
}:

writeShellScript "update-concourse" ''
  set -eu -o pipefail

  declare -A targets=(
    [x86_64-linux]=https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-linux-amd64.tgz
    [aarch64-linux]=https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-linux-arm64.tgz
    [x86_64-darwin]=https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-darwin-amd64.tgz
    [aarch64-darwin]=https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-darwin-arm64.tgz
  )

  printf "version-map = {\n"
  for target in "''${!targets[@]}"; do
    url=''${targets[$target]}
    prefetch=$(nix --extra-experimental-features nix-command store prefetch-file --unpack --json --hash-type sha256 $url)
    hash=$(${jq}/bin/jq -r '.hash' <<< "$prefetch")
    printf "  $target = {\n"
    printf "    url = \"$url\";\n"
    printf "    hash = \"$hash\";\n"
    printf "  };\n"
  done
  printf "};\n"

  # Update version, src and npm deps
  ${lib.getExe nix-update} "$UPDATE_NIX_ATTR_PATH"

  # Update elm deps
  cp "$(nix-build -A "$UPDATE_NIX_ATTR_PATH".src)/web/elm/elm.json" elm.json
  trap 'rm -rf elm.json registry.dat &> /dev/null' EXIT
  ${lib.getExe elm2nix} convert > pkgs/by-name/co/concourse/elm-srcs.nix
  ${lib.getExe nixfmt} pkgs/by-name/co/concourse/elm-srcs.nix
  ${lib.getExe elm2nix} snapshot
  cp registry.dat pkgs/by-name/co/concourse/registry.dat
''
