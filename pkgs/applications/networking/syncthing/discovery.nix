{ stdenv, pkgs }:

let
  common = import ./common.nix {
    inherit pkgs;
  };

in stdenv.mkDerivation rec {
  inherit (common) version src buildInputs preFixup meta;

  name = "syncthing-discovery-${version}";
  buildPhase = common.makeBuildPhase "stdiscosrv";

  installPhase = ''
    install -Dm755 stdiscosrv $out/bin/stdiscosrv
  '';
}
