{ stdenv, newScope, makeWrapper, electron, xdg_utils }:

let
  callPackage = newScope self;
  self = {
    fetchNodeModules = callPackage ./fetchNodeModules.nix {};
    rambox-bare = callPackage ./bare.nix {};
    sencha = callPackage ./sencha {};
  };
in

with self;

stdenv.mkDerivation {
  name = "rambox-${rambox-bare.version}";

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ":";

  installPhase = ''
    makeWrapper ${electron}/bin/electron $out/bin/rambox \
      --add-flags "${rambox-bare} --without-update" \
      --prefix PATH : ${xdg_utils}/bin
  '';
}
