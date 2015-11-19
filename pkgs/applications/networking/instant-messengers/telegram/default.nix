{ stdenv, fetchurl, fetchgit, xorg, glib, qt55, fontconfig, freetype, dbus
, libxkbcommon, makeWrapper, libredirect, xkeyboard_config, makeDesktopItem }:

stdenv.mkDerivation rec {
  name = "telegram-${version}";

  version = "0.9.10";

  src = fetchurl {
    urls = [
      "https://updates.tdesktop.com/tlinux/tsetup.${version}.tar.xz"
    ];
    sha256 = "0lp4piiwxv647bw2fr90qi5ardlhvmr0hyg093wlj429hmv2zah5";
  };

  icon = fetchurl {
    urls = [
      "https://github.com/telegramdesktop/tdesktop/raw/master/Telegram/SourceFiles/art/icon128.png"
    ];
    sha256 = "0vag0d6lkmzn4w25wmna8icrajs56rlc8dr9lh4lzbihgip1vqll";
  };

  buildInputs = [
    stdenv.glibc
    stdenv.cc.cc
    glib
    qt55.qtbase
    xorg.libSM
    xorg.libICE
    xorg.libXrender
    xorg.libXrandr
    xorg.libXcursor
    xorg.libxcb
    fontconfig
    freetype
    xorg.libXext
    xorg.libX11
    dbus
  ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/bin

    cp Telegram $out/bin/Telegram

    fullPath=
    for i in $nativeBuildInputs; do
      fullPath=$fullPath''${fullPath:+:}$i/lib
    done

    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$fullPath:$(cat $NIX_CC/nix-support/orig-cc)/lib64" $out/bin/Telegram \
        --force-rpath

    wrapProgram $out/bin/Telegram \
      --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /usr/share/X11/xkb=${xkeyboard_config}/share/X11/xkb

    # Create the desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps/
    cp ${icon} $out/share/pixmaps/Telegram.png
  '';

  desktopItem = makeDesktopItem {
    name = "Telegram";
    exec = "Telegram";
    icon = "Telegram";
    type = "Application";
    comment = "Telegram Instant Messenger";
    desktopName = "Telegram";
    genericName = "Instant Messenger";
    categories = "Application;Network;";
  };

  meta = {
    description = ''
      Telegram is a messaging app with a focus on speed and security,
      it’s super fast, simple and free.
    '';
    homepage = http://telegram.org/faq;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
