{ stdenv, lib, fetchFromGitHub, fetchgit, pkgconfig, gyp, cmake
, qtbase, qtimageformats, qtwayland
, breakpad, ffmpeg, openalSoft, openssl, zlib, libexif, lzma, libopus
, gtk2, glib, cairo, pango, gdk_pixbuf, atk, libappindicator-gtk2
, libwebp, libunity, dee, libdbusmenu-glib, libva-full, wayland
, xcbutilrenderutil, icu, libSM, libICE, libproxy, libvdpau

, libxcb, xcbutilwm, xcbutilimage, xcbutilkeysyms, libxkbcommon
, libpng, libjpeg, freetype, harfbuzz, pcre16, xproto, libX11
, inputproto, sqlite, dbus
}:

let
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;
  packagedQt = "5.6.2";
  # Hacky: split "1.2.3-4" into "1.2.3" and "4"
  systemQt = (builtins.parseDrvName qtbase.version).name;
  qtLibs = [ qtbase qtimageformats qtwayland ];

in stdenv.mkDerivation rec {
  name = "telegram-desktop-${version}";
  version = "1.0.0";
  qtVersion = lib.replaceStrings ["."] ["_"] packagedQt;

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${version}";
    sha256 = "1qxzi82cgd8klk6rn83rzrmik0s76alarfaknknww5iw5px7gi8b";
  };

  tgaur = fetchgit {
    url = "https://aur.archlinux.org/telegram-desktop.git";
    rev = "957a76f9fb691486341bcf4781ad0ef3d16f6b69";
    sha256 = "01nrvvq0mrdyvamjgqr4z5aahyd1wrf28jyddpfsnixp2w5kxqj8";
  };

  buildInputs = [
    breakpad ffmpeg openalSoft openssl zlib libexif lzma libopus
    gtk2 glib libappindicator-gtk2 libunity cairo pango gdk_pixbuf atk
    dee libdbusmenu-glib libva-full xcbutilrenderutil icu libproxy
    libSM libICE
    # Qt dependencies
    libxcb xcbutilwm xcbutilimage xcbutilkeysyms libxkbcommon
    libpng libjpeg freetype harfbuzz pcre16 xproto libX11
    inputproto sqlite dbus libwebp wayland libvdpau
  ];

  nativeBuildInputs = [ pkgconfig gyp cmake ];

  patches = [ "${tgaur}/aur-fixes.diff" ];

  enableParallelBuilding = true;

  qtSrcs = builtins.map (x: x.src) qtLibs;
  qtNames = builtins.map (x: (builtins.parseDrvName x.name).name) (lib.tail qtLibs);
  qtPatches = qtbase.patches;

  buildCommand = ''
    unpackPhase
    cd "$sourceRoot"

    patchPhase

    sed -i Telegram/gyp/Telegram.gyp \
      -e 's,/usr/include/breakpad,${breakpad}/include/breakpad,g'

    sed -i Telegram/gyp/telegram_linux.gypi \
      -e 's,/usr,/does-not-exist,g' \
      -e 's,-flto,,g'

    sed -i Telegram/gyp/qt.gypi \
      -e 's,${packagedQt},${systemQt},g'

    gypFlagsArray=(
      "-Dlinux_path_qt=$PWD/../qt"
      "-Dlinux_lib_ssl=-lssl"
      "-Dlinux_lib_crypto=-lcrypto"
      "-Dlinux_lib_icu=-licuuc -licutu -licui18n"
    )

    export QMAKE=$PWD/../qt/bin/qmake
    ( mkdir -p ../Libraries
      cd ../Libraries
      for i in $qtSrcs; do
        tar -xaf $i
      done
      cd qtbase-*
      # This patch is often outdated but the fixes doesn't feel very important
      patch -p1 < ../../$sourceRoot/Telegram/Patches/qtbase_${qtVersion}.diff || true
      for i in $qtPatches; do
        patch -p1 < $i
      done
      ${qtbase.postPatch}
      cd ..

      export configureFlags="-prefix "$PWD/../qt" -release -opensource -confirm-license -system-zlib \
        -system-libpng -system-libjpeg -system-freetype -system-harfbuzz -system-pcre -system-xcb \
        -system-xkbcommon-x11 -no-eglfs -no-gtkstyle -static -nomake examples -nomake tests \
        -no-directfb -system-proxies -openssl-linked -dbus-linked -system-sqlite -verbose \
        ${lib.optionalString (!system-x86_64) "-no-sse2"} -no-sse3 -no-ssse3 \
        -no-sse4.1 -no-sse4.2 -no-avx -no-avx2 -no-mips_dsp -no-mips_dspr2"
      export dontAddPrefix=1
      export MAKEFLAGS=-j$NIX_BUILD_CORES

      ( cd qtbase-*
        configurePhase
        buildPhase
        make install
      )
      for i in $qtNames; do
        ( cd $i-*
          $QMAKE
          buildPhase
          make install
        )
      done
    )

    ( cd Telegram/gyp
      gyp "''${gypFlagsArray[@]}" --depth=. --generator-output=../.. -Goutput_dir=out Telegram.gyp --format=cmake
    )

    ( cd out/Release
      export ASM=$(type -p gcc)
      cmake .
      # For some reason, it can't find stdafx.h -- we need to build dependencies till it fails and then retry.
      buildPhase || true
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -include stdafx.h"
      buildPhase
    )

    install -Dm755 out/Release/Telegram $out/bin/telegram-desktop
    mkdir -p $out/share/applications $out/share/kde4/services
    sed "s,/usr/bin,$out/bin,g" $tgaur/telegramdesktop.desktop > $out/share/applications/telegramdesktop.desktop
    sed "s,/usr/bin,$out/bin,g" $tgaur/tg.protocol > $out/share/kde4/services/tg.protocol
    for icon_size in 16 32 48 64 128 256 512; do
      install -Dm644 "Telegram/Resources/art/icon''${icon_size}.png" "$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps/telegram-desktop.png"
    done

    fixupPhase
  '';

  meta = with stdenv.lib; {
    description = "Telegram Desktop messaging app";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "https://desktop.telegram.org/";
    maintainers = with maintainers; [ abbradar garbas ];
  };
}
