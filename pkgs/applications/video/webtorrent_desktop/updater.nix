{ lib, stdenv, writeScript, fetchFromGitHub, nodePackages, jq, curl, nix-prefetch-github, nix }:

let
  source = lib.importJSON ./source.json;
in

writeScript "webtorrent-desktop-sources" ''
  #!${stdenv.shell}
  cd ${toString ./.}
  VERSION=$(${curl}/bin/curl https://api.github.com/repos/webtorrent/webtorrent-desktop/releases/latest | ${jq}/bin/jq -r .tag_name)
  if [[ "${source.rev}" == "$VERSION" ]]
  then echo "Version up to date $VERSION"
  else
    echo "Updating from ${source.rev} -> $VERSION"
    SHA=$(${nix-prefetch-github}/bin/nix-prefetch-github webtorrent webtorrent-desktop --rev "$VERSION" | ${jq}/bin/jq -r .sha256)
    echo "Got sha $SHA"
    cat > source.json <<EOF
  { "rev":"$VERSION"
  , "sha256":"$SHA"
  }
  EOF

    SRC=$(${nix}/bin/nix-build --no-out-link -E "
    with import ../../../../default.nix {};
    let
      source = lib.importJSON ./source.json;
    in
      fetchFromGitHub {
        owner = \"webtorrent\";
        repo = \"webtorrent-desktop\";
        inherit (source) rev sha256;
      }
    ")
    ${nodePackages.node2nix}/bin/node2nix \
      --nodejs-12 \
      -i $SRC/package.json \
      -l $SRC/package-lock.json \
      -c from-source.nix \
      --strip-optional-dependencies \
      --supplement-input supplement.json
  fi
''

