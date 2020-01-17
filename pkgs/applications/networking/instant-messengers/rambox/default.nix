{ stdenv, newScope, makeWrapper
, electron, xdg_utils, makeDesktopItem
, auth0ClientID ? "0spuNKfIGeLAQ_Iki9t3fGxbfJl3k8SU"
, auth0Domain ? "nixpkgs.auth0.com" }:

let
  callPackage = newScope self;
  self = {
    fetchNodeModules = callPackage ./fetchNodeModules.nix {};
    rambox-bare = callPackage ./bare.nix {
      inherit auth0ClientID auth0Domain;
    };
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

  dontUnpack = true;

  dontWrapGApps = true; # we only want $gappsWrapperArgs here

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/rambox \
      --add-flags "${rambox-bare} --without-update" \
      --prefix PATH : ${xdg_utils}/bin
  '';

  meta = rambox-bare.meta // {
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
