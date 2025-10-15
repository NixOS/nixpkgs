{ stdenv, fetchgit, pkgs, }:

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";

  pkgs = import nixpkgs { config = {}; overlays = []; };
in

stdenv.mkDerivation {
  pname = "sglauncher";
  version = "1.0";
  src = fetchgit {
    url = "https://codeberg.org/ItsZariep/SGLauncher";
    hash = "sha256-NEAEqH4r7GG8f41ysbmGEyiWPYrc792rTlmMBp2csmw=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.gtk3 ];

  buildPhase = ''
    cd ./src
    ${pkgs.gnumake}/bin/make sglauncher SHELL=${pkgs.bash}/bin/bash
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp sglauncher $out/bin
  '';

  meta = with pkgs.lib; {
    description = "Simple GTK Launcher";
    license = licenses.gpl3Only;
  };
}
