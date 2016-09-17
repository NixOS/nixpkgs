{ pkgs ? (import <nixpkgs> {}) }:

with pkgs;

let

  primary-src = callPackage ./default-primary-src.nix {};

in

stdenv.mkDerivation {
  name = "generate-libreoffice-srcs-shell";

  buildCommand = "exit 1";

  downloadList = stdenv.mkDerivation {
    name = "libreoffice-${primary-src.version}-download-list";
    inherit (primary-src) src version;
    builder = ./download-list-builder.sh;
  };

  shellHook = ''
    function generate {
      ./generate-libreoffice-srcs.sh | tee libreoffice-srcs.nix
    }
  '';
}
