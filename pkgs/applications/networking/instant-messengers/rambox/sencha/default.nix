{ stdenv, callPackage, makeWrapper }:

let
  sencha-bare = callPackage ./bare.nix {};
in

stdenv.mkDerivation {
  name = "sencha-${sencha-bare.version}";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${sencha-bare}/sencha $out/bin/sencha
  '';
}
