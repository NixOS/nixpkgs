{ stdenv, newScope, makeWrapper, electron, xdg_utils, makeDesktopItem }:

let
  callPackage = newScope self;
  self = {
    fetchNodeModules = callPackage ./fetchNodeModules.nix {};
    rambox-bare = callPackage ./bare.nix {};
    sencha = callPackage ./sencha {};
  };
  desktopItem = makeDesktopItem rec {
    name = "Rambox";
    exec = "rambox";
    icon = "${self.rambox-bare}/resources/Icon.png";
    desktopName = name;
    genericName = "Rambox messenger";
    categories = "Network;";
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
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';
}
