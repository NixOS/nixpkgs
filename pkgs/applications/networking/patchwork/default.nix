{ stdenv, pkgs, lib, fetchFromGitHub, nodePackages, callPackage, xorg }:

with stdenv.lib;

let
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    neededNatives = [ python ] ++ optional (stdenv.isLinux) utillinux;
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  version = "3.8.0";
  name = "scuttlebut-${version}";

  src = fetchFromGitHub {
    owner = "ssbc";
    repo = "scuttlebut";
    rev = "${version}";
    sha256 = "1g7v0qhvgzpb050hf45pibp68qd67hnnry5npw58f4dvaxdd8yhd";
  };

  buildInputs = [ xorg.libX11 ];

  meta = with lib; {
    description = "A decentralized messaging and sharing app built on top of Secure Scuttlebutt (SSB)";
    homepage = https://www.scuttlebutt.nz/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
