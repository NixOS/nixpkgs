{ stdenv, newScope, makeWrapper
, wrapGAppsHook, gnome3, glib
, electron_3, xdg_utils, makeDesktopItem
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

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];

  buildInputs = [ glib gnome3.gsettings_desktop_schemas ];
  unpackPhase = ":";

  dontWrapGApps = true; # we only want $gappsWrapperArgs here

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_3}/bin/electron $out/bin/rambox \
      --add-flags "${rambox-bare} --without-update" \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${xdg_utils}/bin
  '';

  inherit (rambox-bare.meta // {
    platforms = [ "i686-linux" "x86_64-linux" ];
  });
}
