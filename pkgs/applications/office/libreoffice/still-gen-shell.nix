{ pkgs ? (import <nixpkgs> {}) }:

with pkgs;

let

  primary-src = callPackage ./still-primary-src.nix {};

in

stdenv.mkDerivation {
  name = "generate-libreoffice-srcs-shell";

  buildCommand = "exit 1";

  downloadList = stdenv.mkDerivation {
    name = "libreoffice-${primary-src.version}-download-list";
    inherit (primary-src) src version;
    builder = ./download-list-builder.sh;
  };

  buildInputs = [ python3 ];

  shellHook = ''
    function generate {
      python3 generate-libreoffice-srcs.py > libreoffice-srcs-still.nix
    }
  '';
}
