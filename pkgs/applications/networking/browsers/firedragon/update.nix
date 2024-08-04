{
  writeShellScript,
  lib,
  coreutils,
  findutils,
  gnugrep,
  gnused,
  curl,
  jq,
  git,
  nix,
  moreutils,
  ...
}:
let
  path = lib.makeBinPath [
    coreutils
    curl
    findutils
    gnugrep
    gnused
    jq
    moreutils
    git
    nix
  ];
in
writeShellScript "update-firedragon" ''
  set -euo pipefail
  PATH=${path}

  srcJson=pkgs/firedragon/version.json
  localVer=$(jq -r .version <$srcJson)

  latestVer=$(curl -s https://gitlab.com/api/v4/projects/55893651/releases/ | jq '.[0].tag_name' -r | sed 's/v//g')

  if [ "$localVer" == "$latestVer" ]; then
    exit 0
  fi

  latestSha256=$(nix-prefetch-url --type sha256 "https://gitlab.com/api/v4/projects/55893651/packages/generic/firedragon/$latestVer/firedragon-v$latestVer.source.tar.zst")
  latestHash=$(nix-hash --to-sri --type sha256 "$latestSha256")

  jq \
    --arg latestVer "$latestVer" --arg latestHash "$latestHash" \
    ".version = \$latestVer | .hash = \$latestHash" \
    "$srcJson" | sponge $srcJson
''
