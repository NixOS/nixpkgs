{ stdenv, newScope, makeWrapper, electron, xdg_utils, makeDesktopItem
# These credentials are only for this derivation. If you want to get credentials
# for another distribution, go to https://auth0.com. If you want to reuse the same
# domain, drop a line at yegortimoshenko@gmail.com!
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

  unpackPhase = ":";

  installPhase = ''
    makeWrapper ${electron}/bin/electron $out/bin/rambox \
      --add-flags "${rambox-bare} --without-update" \
      --prefix PATH : ${xdg_utils}/bin
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';
}
