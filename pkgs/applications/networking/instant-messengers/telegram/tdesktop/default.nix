{ stdenv, lib, fetchFromGitHub, fetchgit, qtbase, qtimageformats
, breakpad, ffmpeg, openalSoft, openssl, zlib, libexif, lzma, libopus
, gtk2, glib, cairo, pango, gdk_pixbuf, atk, libappindicator-gtk2
, libwebp, libunity, dee, libdbusmenu-glib, libva

, pkgconfig, libxcb, xcbutilwm, xcbutilimage, xcbutilkeysyms
, libxkbcommon, libpng, libjpeg, freetype, harfbuzz, pcre16
, xproto, libX11, inputproto, sqlite, dbus
}:

let
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;
  packagedQt = "5.6.0";
  # Hacky: split "1.2.3-4" into "1.2.3" and "4"
  systemQt = (builtins.parseDrvName qtbase.version).name;

in stdenv.mkDerivation rec {
  name = "telegram-desktop-${version}";
  version = "0.10.1";
  qtVersion = lib.replaceStrings ["."] ["_"] packagedQt;

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${version}";
    sha256 = "08isxwif6zllglkpd9i7ypxm2s4bibzqris48607bafr88ylksdk";
  };

  tgaur = fetchgit {
    url = "https://aur.archlinux.org/telegram-desktop.git";
    rev = "9ce7be9efed501f988bb099956fa63729f2c25ea";
    sha256 = "1wp6lqscpm2byizchm0bj48dg9bga02r9r69ns10zxk0gk0qvvdn";
  };

  buildInputs = [
    breakpad ffmpeg openalSoft openssl zlib libexif lzma libopus
    gtk2 glib libappindicator-gtk2 libunity cairo pango gdk_pixbuf atk
    dee libdbusmenu-glib libva
    # Qt dependencies
    libxcb xcbutilwm xcbutilimage xcbutilkeysyms libxkbcommon
    libpng libjpeg freetype harfbuzz pcre16 xproto libX11
    inputproto sqlite dbus libwebp
  ];

  nativeBuildInputs = [ pkgconfig ];

  enableParallelBuilding = true;

  qmakeFlags = [
    "CONFIG+=release"
    "DEFINES+=TDESKTOP_DISABLE_AUTOUPDATE"
    "DEFINES+=TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
    "INCLUDEPATH+=${breakpad}/include/breakpad"
    "QT_TDESKTOP_VERSION=${systemQt}"
  ];

  qtSrcs = [ qtbase.src qtimageformats.src ];
  qtPatches = qtbase.patches;

  buildCommand = ''
    unpackPhase
    cd "$sourceRoot"

    patchPhase
    sed -i 'Telegram/Telegram.pro' \
      -e 's,CUSTOM_API_ID,,g' \
      -e 's,/usr,/does-not-exist,g' \
      -e 's, -flto,,g' \
      -e 's,LIBS += .*libbreakpad_client.a,LIBS += ${breakpad}/lib/libbreakpad_client.a,' \
      -e 's, -static-libstdc++,,g' \
      -e '/LIBS += .*libxkbcommon.a/d'

    export qmakeFlags="$qmakeFlags QT_TDESKTOP_PATH=$PWD/../qt"

    export QMAKE=$PWD/../qt/bin/qmake
    ( mkdir -p ../Libraries
      cd ../Libraries
      for i in $qtSrcs; do
        tar -xaf $i
      done
      cd qtbase-*
      # This patch is outdated but the fixes doesn't feel very important
      patch -p1 < ../../$sourceRoot/Telegram/Patches/qtbase_${qtVersion}.diff || true
      for i in $qtPatches; do
        patch -p1 < $i
      done
      ${qtbase.postPatch}
      cd ..

      export configureFlags="-prefix "$PWD/../qt" -release -opensource -confirm-license -system-zlib \
        -system-libpng -system-libjpeg -system-freetype -system-harfbuzz -system-pcre -system-xcb \
        -system-xkbcommon-x11 -no-opengl -static -nomake examples -nomake tests \
        -openssl-linked -dbus-linked -system-sqlite -verbose -no-gtkstyle \
        ${lib.optionalString (!system-x86_64) "-no-sse2"} -no-sse3 -no-ssse3 \
        -no-sse4.1 -no-sse4.2 -no-avx -no-avx2 -no-mips_dsp -no-mips_dspr2"
      export dontAddPrefix=1
      export MAKEFLAGS=-j$NIX_BUILD_CORES

      ( cd qtbase-*
        configurePhase
        buildPhase
        make install
      )

      ( cd qtimageformats-*
        $QMAKE
        buildPhase
        make install
      )
    )

    ( mkdir -p Linux/obj/codegen_style/Debug
      cd Linux/obj/codegen_style/Debug
      $QMAKE $qmakeFlags ../../../../Telegram/build/qmake/codegen_style/codegen_style.pro
      buildPhase
    )
    ( mkdir -p Linux/obj/codegen_numbers/Debug
      cd Linux/obj/codegen_numbers/Debug
      $QMAKE $qmakeFlags ../../../../Telegram/build/qmake/codegen_numbers/codegen_numbers.pro
      buildPhase
    )
    ( mkdir -p Linux/DebugIntermediateLang
      cd Linux/DebugIntermediateLang
      $QMAKE $qmakeFlags ../../Telegram/MetaLang.pro
      buildPhase
    )

    ( mkdir -p Linux/ReleaseIntermediate
      cd Linux/ReleaseIntermediate
      $QMAKE $qmakeFlags ../../Telegram/Telegram.pro
      pattern="^PRE_TARGETDEPS +="
      grep "$pattern" "../../Telegram/Telegram.pro" | sed "s/$pattern//g" | xargs make
      buildPhase
    )

    install -Dm755 Linux/Release/Telegram $out/bin/telegram-desktop
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
