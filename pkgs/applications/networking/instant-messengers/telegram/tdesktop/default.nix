{ stdenv, lib, fetchFromGitHub, fetchgit, qtbase, qtimageformats
, breakpad, ffmpeg, openalSoft, openssl, zlib, libexif, lzma, libopus
, gtk2, glib, cairo, pango, gdk_pixbuf, atk, libappindicator-gtk2
, libunity, dee, libdbusmenu-glib, libva, qmakeHook

, pkgconfig, libxcb, xcbutilwm, xcbutilimage, xcbutilkeysyms
, libxkbcommon, libpng, libjpeg, freetype, harfbuzz, pcre16
, xproto, libX11, inputproto, sqlite, dbus
}:

let
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;
in stdenv.mkDerivation rec {
  name = "telegram-desktop-${version}";
  version = "0.9.33";
  qtVersion = lib.replaceStrings ["."] ["_"] qtbase.version;

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${version}";
    sha256 = "020vwm7h22951v9zh457d82qy5ifp746vwishkvb16h1vwr1qx4s";
  };

  tgaur = fetchgit {
    url = "https://aur.archlinux.org/telegram-desktop.git";
    rev = "df47a864282959b103a08b65844e9088e012fdb3";
    sha256 = "1v1dbi8yiaf2hgghniykm5qbnda456xj3zfjnbqysn41f5cn40h4";
  };

  buildInputs = [
    breakpad ffmpeg openalSoft openssl zlib libexif lzma libopus
    gtk2 glib libappindicator-gtk2 libunity cairo pango gdk_pixbuf atk
    dee libdbusmenu-glib libva qtbase qmakeHook
    # Qt dependencies
    libxcb xcbutilwm xcbutilimage xcbutilkeysyms libxkbcommon
    libpng libjpeg freetype harfbuzz pcre16 xproto libX11
    inputproto sqlite dbus
  ];

  nativeBuildInputs = [ pkgconfig ];

  enableParallelBuilding = true;

  qmakeFlags = [
    "CONFIG+=release"
    "DEFINES+=TDESKTOP_DISABLE_AUTOUPDATE"
    "DEFINES+=TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
    "INCLUDEPATH+=${gtk2}/include/gtk-2.0"
    "INCLUDEPATH+=${glib}/include/glib-2.0"
    "INCLUDEPATH+=${glib.out}/lib/glib-2.0/include"
    "INCLUDEPATH+=${cairo}/include/cairo"
    "INCLUDEPATH+=${pango}/include/pango-1.0"
    "INCLUDEPATH+=${gtk2.out}/lib/gtk-2.0/include"
    "INCLUDEPATH+=${gdk_pixbuf}/include/gdk-pixbuf-2.0"
    "INCLUDEPATH+=${atk}/include/atk-1.0"
    "INCLUDEPATH+=${libappindicator-gtk2}/include/libappindicator-0.1"
    "INCLUDEPATH+=${libunity}/include/unity"
    "INCLUDEPATH+=${dee}/include/dee-1.0"
    "INCLUDEPATH+=${libdbusmenu-glib}/include/libdbusmenu-glib-0.4"
    "INCLUDEPATH+=${breakpad}/include/breakpad"
    "LIBS+=-lcrypto"
    "LIBS+=-lssl"
    "LIBS+=-lz"
    "LIBS+=-lgobject-2.0"
    "LIBS+=-lxkbcommon"
    "LIBS+=-lX11"
    "LIBS+=${breakpad}/lib/libbreakpad_client.a"
    "LIBS+=./../../../Libraries/QtStatic/qtbase/plugins/platforms/libqxcb.a"
    "LIBS+=./../../../Libraries/QtStatic/qtimageformats/plugins/imageformats/libqwebp.a"
  ];

  qtSrcs = qtbase.srcs ++ [ qtimageformats.src ];
  qtPatches = qtbase.patches;

  dontUseQmakeConfigure = true;

  buildCommand = ''
    unpackPhase
    cd "$sourceRoot"
    patchPhase
    sed -i 'Telegram/Telegram.pro' \
      -e 's/CUSTOM_API_ID//g' \
      -e 's,/usr,/does-not-exist,g' \
      -e '/LIBS += .*libxkbcommon.a/d' \
      -e '/LIBS += .*libz.a/d' \
      -e '/LIBS += .*libbreakpad_client.a/d' \
      -e 's,-flto ,,g'
    echo "Q_IMPORT_PLUGIN(QXcbIntegrationPlugin)" >> Telegram/SourceFiles/stdafx.cpp

    ( mkdir -p ../Libraries
      cd ../Libraries
      for i in $qtSrcs; do
        tar -xaf $i
      done
      mv qt-everywhere-opensource-src-* QtStatic
      mv qtbase-opensource-src-* ./QtStatic/qtbase
      mv qtimageformats-opensource-src-* ./QtStatic/qtimageformats
      cd QtStatic/qtbase
      patch -p1 < ../../../$sourceRoot/Telegram/_qtbase_${qtVersion}_patch.diff
      cd ..
      for i in $qtPatches; do
        patch -p1 < $i
      done
      ${qtbase.postPatch}

      export configureFlags="-prefix "../../qt" -release -opensource -confirm-license -system-zlib \
        -system-libpng -system-libjpeg -system-freetype -system-harfbuzz -system-pcre -system-xcb \
        -system-xkbcommon-x11 -no-opengl -static -nomake examples -nomake tests \
        -openssl-linked -dbus-linked -system-sqlite -verbose \
        ${lib.optionalString (!system-x86_64) "-no-sse2"} -no-sse3 -no-ssse3 \
        -no-sse4.1 -no-sse4.2 -no-avx -no-avx2 -no-mips_dsp -no-mips_dspr2"
      export dontAddPrefix=1
      export buildFlags="module-qtbase module-qtimageformats"
      export installFlags="module-qtbase-install_subtargets module-qtimageformats-install_subtargets"

      ( export MAKEFLAGS=-j$NIX_BUILD_CORES
        configurePhase
      )
      buildPhase
      installPhase
    )

    ( mkdir -p Linux/DebugIntermediateStyle
      cd Linux/DebugIntermediateStyle
      qmake CONFIG+=debug ../../Telegram/MetaStyle.pro
      buildPhase
    )
    ( mkdir -p Linux/DebugIntermediateLang
      cd Linux/DebugIntermediateLang
      qmake CONFIG+=debug ../../Telegram/MetaLang.pro
      buildPhase
    )

    ( mkdir -p Linux/ReleaseIntermediate
      cd Linux/ReleaseIntermediate
      qmake $qmakeFlags ../../Telegram/Telegram.pro
      pattern="^PRE_TARGETDEPS +="
      grep "$pattern" "../../Telegram/Telegram.pro" | sed "s/$pattern//g" | xargs make

      qmake $qmakeFlags ../../Telegram/Telegram.pro
      buildPhase
    )

    install -Dm755 Linux/Release/Telegram $out/bin/telegram-desktop
    mkdir -p $out/share/applications $out/share/kde4/services
    sed "s,/usr/bin,$out/bin,g" $tgaur/telegramdesktop.desktop > $out/share/applications/telegramdesktop.desktop
    sed "s,/usr/bin,$out/bin,g" $tgaur/tg.protocol > $out/share/kde4/services/tg.protocol
    for icon_size in 16 32 48 64 128 256 512; do
      install -Dm644 "Telegram/SourceFiles/art/icon''${icon_size}.png" "$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps/telegram-desktop.png"
    done

    fixupPhase
  '';

  meta = with stdenv.lib; {
    description = "Telegram Desktop messaging app";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "https://desktop.telegram.org/";
    maintainers = with maintainers; [ abbradar ];
  };
}
