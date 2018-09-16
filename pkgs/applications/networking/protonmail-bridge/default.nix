{ stdenv, fetchurl, lib, qtbase, qtmultimedia, qtsvg, qtdeclarative, qttools, full,
  libsecret, libGL, libpulseaudio, glib, makeWrapper, makeDesktopItem }:

let
  version = "1.0.6-1";

  description = ''
    An application that runs on your computer in the background and seamlessly encrypts
    and decrypts your mail as it enters and leaves your computer.

    To work, gnome-keyring service must be enabled.
  '';

  desktopItem = makeDesktopItem {
    name = "Desktop-Bridge";
    exec = "Desktop-Bridge";
    icon = "desktop-bridge";
    comment = stdenv.lib.replaceStrings ["\n"] [" "] description;
    desktopName = "ProtonMail Bridge";
    genericName = "ProtonMail Bridge for Linux";
    categories = "Utility;Security;Network;Email";
  };
in stdenv.mkDerivation rec {
  name = "protonmail-bridge-${version}";

  src = fetchurl {
    url = "https://protonmail.com/download/protonmail-bridge_${version}_amd64.deb";
    sha256 = "1as4xdsik2w9clbrwp1k00491324cg6araz3jq2m013yg1cild28";
  };

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  unpackCmd = ''
    ar p "$src" data.tar.xz | tar xJ
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib,share/applications}
    # mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}

    cp -r usr/lib/protonmail/bridge/Desktop-Bridge{,.sh} $out/lib
    # cp usr/share/icons/protonmail/Desktop-Bridge.svg $out/share/icons/hicolor/scalable/apps/desktop-bridge.svg
    cp ${desktopItem}/share/applications/* $out/share/applications

    ln -s $out/lib/Desktop-Bridge $out/bin/Desktop-Bridge
  '';

  postFixup = let
    rpath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      qtbase
      qtmultimedia
      qtsvg
      qtdeclarative
      qttools
      libGL
      libsecret
      libpulseaudio
      glib
    ];

    qtPath = prefix: "${full}/${prefix}";
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${rpath}" \
      $out/lib/Desktop-Bridge

    wrapProgram $out/lib/Desktop-Bridge \
      --set QT_PLUGIN_PATH "${qtPath qtbase.qtPluginPrefix}" \
      --set QML_IMPORT_PATH "${qtPath qtbase.qtQmlPrefix}" \
      --set QML2_IMPORT_PATH "${qtPath qtbase.qtQmlPrefix}" \
  '';

  meta = with stdenv.lib; {
    homepage = https://www.protonmail.com/bridge;
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lightdiscord ];

    inherit description;
  };
}
