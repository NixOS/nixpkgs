{ stdenv, lib, pkgs }:

let
  common = import ./common.nix {
    inherit pkgs;
  };

in stdenv.mkDerivation rec {
  inherit (common) version src buildInputs preFixup meta;

  name = "syncthing-relay-${version}";
  buildPhase = common.makeBuildPhase "strelaysrv";

  installPhase = ''
    mkdir -p $out/lib/systemd/system $out/bin

    install -Dm755 strelaysrv $out/bin/strelaysrv
  '' + lib.optionalString (stdenv.isLinux) ''
    substitute cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
               $out/lib/systemd/system/strelaysrv.service \
               --replace /usr/bin/strelaysrv $out/bin/strelaysrv
  '';
}
