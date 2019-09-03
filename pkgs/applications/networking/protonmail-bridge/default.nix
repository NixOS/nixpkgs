{ stdenv, fetchurl, lib, qtbase, qtmultimedia, qtsvg, qtdeclarative, qttools, qtgraphicaleffects, qtquickcontrols2, full
, libsecret, libGL, libpulseaudio, glib, wrapQtAppsHook, makeDesktopItem, mkDerivation }:

let
  version = "1.1.6-1";

  description = ''
    An application that runs on your computer in the background and seamlessly encrypts
    and decrypts your mail as it enters and leaves your computer.

    To work, gnome-keyring service must be enabled.
  '';

  desktopItem = makeDesktopItem {
    name = "protonmail-bridge";
    exec = "protonmail-bridge";
    icon = "protonmail-bridge";
    comment = stdenv.lib.replaceStrings ["\n"] [" "] description;
    desktopName = "ProtonMail Bridge";
    genericName = "ProtonMail Bridge for Linux";
    categories = "Utility;Security;Network;Email";
  };

in mkDerivation rec {
  pname = "protonmail-bridge";
  inherit version;

  src = fetchurl {
    url = "https://protonmail.com/download/protonmail-bridge_${version}_amd64.deb";
    sha256 = "108dql9q5znsqjkrs41pc6psjbg5bz09rdmjl036xxbvsdvq4a8r";
  };

  sourceRoot = ".";

  unpackCmd = ''
    ar p "$src" data.tar.xz | tar xJ
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib,share/applications}
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}

    cp -r usr/lib/protonmail/bridge/protonmail-bridge $out/lib
    cp usr/share/icons/protonmail/ProtonMail_Bridge.svg $out/share/icons/hicolor/scalable/apps/protonmail-bridge.svg
    cp ${desktopItem}/share/applications/* $out/share/applications

    ln -s $out/lib/protonmail-bridge $out/bin/protonmail-bridge
  '';

  postFixup = let
    rpath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      qtbase
      qtquickcontrols2
      qtgraphicaleffects
      qtmultimedia
      qtsvg
      qtdeclarative
      qttools
      libGL
      libsecret
      libpulseaudio
      glib
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${rpath}" \
      $out/lib/protonmail-bridge
  '';

  buildInputs = [ qtbase qtquickcontrols2 qtmultimedia qtgraphicaleffects qtdeclarative ];

  meta = with stdenv.lib; {
    homepage = "https://www.protonmail.com/bridge";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lightdiscord ];

    inherit description;
  };
}
