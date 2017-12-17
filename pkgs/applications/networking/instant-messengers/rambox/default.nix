{ stdenv, newScope, makeWrapper, electron, xdg_utils, fetchurl, makeDesktopItem
, auth0ClientID ? "0spuNKfIGeLAQ_Iki9t3fGxbfJl3k8SU"
, auth0Domain ? "nixpkgs.auth0.com"
, disableTooltips ? false }:

let
  callPackage = newScope self;
  self = {
    fetchNodeModules = callPackage ./fetchNodeModules.nix {};
    rambox-bare = callPackage ./bare.nix {
      inherit auth0ClientID auth0Domain disableTooltips;
    };
    sencha = callPackage ./sencha {};
  };
  # https://github.com/NixOS/nixpkgs/pull/32741#issuecomment-352203170
  electron_1_7 = electron.overrideAttrs (oldAttrs: rec {
    version = "1.7.5";
    name = "electron-${version}";
    src = fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
      sha256 = "1z1dzk6d2mfyms8lj8g6jn76m52izbd1d7c05k8h88m1syfsgav5";
      name = "${name}.zip";
    };
    meta.platforms = [ "x86_64-linux" ];
  });
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
    makeWrapper ${electron_1_7}/bin/electron $out/bin/rambox \
      --add-flags "${rambox-bare} --without-update" \
      --prefix PATH : ${xdg_utils}/bin
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';
}
