{ stdenv, fetchurl, unzip, lv2 }:

let
  base = import ./base.nix { inherit stdenv fetchurl unzip lv2; };
in
stdenv.mkDerivation {
  pname = "molot-mono-lite";

  version = base.version;
  src = base.src;
  unpackPhase  = base.unpackPhase;
  buildInputs = base.buildInputs;
  installFlags = base.installFlags;

  prePatch = ''
   cd  Molot_Mono_Lite
  '';
}
