{ mkDerivation, lib, fetchFromGitHub, fetchsvn, fetchpatch
, pkgconfig, pythonPackages, cmake, wrapGAppsHook, wrapQtAppsHook, gcc9
, qtbase, qtimageformats, gtk3, libappindicator-gtk3, libnotify, xdg_utils
, dee, ffmpeg, openalSoft, minizip, libopus, alsaLib, libpulseaudio, range-v3
}:

with lib;

mkDerivation rec {
  pname = "telegram-desktop";
  version = "1.8.2";
  # Note: Due to our strong dependency on the Arch patches it's probably best
  # to also wait for the Arch update (especially if the patches don't apply).

  # Telegram-Desktop with submodules
  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${version}";
    sha256 = "0dls6s8721zjm8351fcgfbsifr9d7wsxbf5dra5cbk8r555ibf3j";
    fetchSubmodules = true;
  };

  # Arch patches (svn export telegram-desktop/trunk)
  archPatches = fetchsvn {
    url = "svn://svn.archlinux.org/community/telegram-desktop/trunk";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    rev = "498563";
    sha256 = "0g2y6impygqhfiqnyxc1ivxwl8j82q9qcnkqcjn6mwj3cisyxwnl";
  };
  privateHeadersPatch = fetchpatch {
    url = "https://github.com/telegramdesktop/tdesktop/commit/b9d3ba621eb8af638af46c6b3cfd7a8330bf0dd5.patch";
    sha256 = "1s5xvcp9dk0jfywssk8xfcsh7bk5xxif8xqnba0413lfx5rgvs5v";
  };

  # Note: It would be best if someone could get as many patches upstream as
  # possible (we currently depend a lot on custom patches...).
  patches = [
    "${archPatches}/tdesktop.patch"
    "${archPatches}/no-gtk2.patch"
    # "${archPatches}/Use-system-wide-font.patch"
    "${archPatches}/tdesktop_lottie_animation_qtdebug.patch"
  ];

  postPatch = ''
    substituteInPlace Telegram/SourceFiles/platform/linux/linux_libs.cpp \
      --replace '"appindicator3"' '"${libappindicator-gtk3}/lib/libappindicator3.so"'
    substituteInPlace Telegram/SourceFiles/platform/linux/linux_libnotify.cpp \
      --replace '"notify"' '"${libnotify}/lib/libnotify.so"'
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [ pkgconfig pythonPackages.gyp cmake wrapGAppsHook wrapQtAppsHook gcc9 ];

  buildInputs = [
    qtbase qtimageformats gtk3 libappindicator-gtk3
    dee ffmpeg openalSoft minizip libopus alsaLib libpulseaudio range-v3
  ];

  enableParallelBuilding = true;

  GYP_DEFINES = concatStringsSep "," [
    "TDESKTOP_DISABLE_CRASH_REPORTS"
    "TDESKTOP_DISABLE_AUTOUPDATE"
    "TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
  ];

  NIX_CFLAGS_COMPILE = [
    "-DTDESKTOP_DISABLE_CRASH_REPORTS"
    "-DTDESKTOP_DISABLE_AUTOUPDATE"
    "-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
    "-I${minizip}/include/minizip"
    # See Telegram/gyp/qt.gypi
    "-I${getDev qtbase}/mkspecs/linux-g++"
  ] ++ concatMap (x: [
    "-I${getDev qtbase}/include/${x}"
    "-I${getDev qtbase}/include/${x}/${qtbase.version}"
    "-I${getDev qtbase}/include/${x}/${qtbase.version}/${x}"
    "-I${getDev libopus}/include/opus"
    "-I${getDev alsaLib}/include/alsa"
    "-I${getDev libpulseaudio}/include/pulse"
    ]) [ "QtCore" "QtGui" "QtDBus" ];
  CPPFLAGS = NIX_CFLAGS_COMPILE;

  preConfigure = ''
    # Patches to revert:
    patch -R -Np1 -i "${archPatches}/demibold.patch"
    patch -R -Np1 -i "${privateHeadersPatch}"

    # Patches to apply:
    pushd "Telegram/ThirdParty/libtgvoip"
    patch -Np1 -i "${archPatches}/libtgvoip.patch"
    popd

    # disable static-qt for rlottie
    sed "/RLOTTIE_WITH_STATIC_QT/d" -i "Telegram/gyp/lib_rlottie.gyp"

    sed -i Telegram/gyp/telegram_linux.gypi \
      -e 's,/usr,/does-not-exist,g' \
      -e 's,appindicator-0.1,appindicator3-0.1,g' \
      -e 's,-flto,,g'

    sed -i Telegram/gyp/qt.gypi \
      -e "s,/usr/include/qt/QtCore/,${qtbase.dev}/include/QtCore/,g" \
      -e 's,\d+",\d+" | head -n1,g'
    sed -i Telegram/gyp/qt_moc.gypi \
      -e "s,/usr/bin/moc,moc,g"
    sed -i Telegram/gyp/qt_rcc.gypi \
      -e "s,/usr/bin/rcc,rcc,g"

    # Build system assumes x86, but it works fine on non-x86 if we patch this one flag out
    sed -i Telegram/ThirdParty/libtgvoip/libtgvoip.gyp \
      -e "/-msse2/d"

    gyp \
      -Dapi_id=17349 \
      -Dapi_hash=344583e45741c457fe1862106095a5eb \
      -Dbuild_defines=${GYP_DEFINES} \
      -Gconfig=Release \
      --depth=Telegram/gyp \
      --generator-output=../.. \
      -Goutput_dir=out \
      --format=cmake \
      Telegram/gyp/Telegram.gyp

    cd out/Release

    NUM=$((`wc -l < CMakeLists.txt` - 2))
    sed -i "$NUM r $archPatches/CMakeLists.inj" CMakeLists.txt

    export ASM=$(type -p gcc)
  '';

  cmakeFlags = [ "-UTDESKTOP_OFFICIAL_TARGET" ];

  installPhase = ''
    install -Dm755 Telegram $out/bin/telegram-desktop

    mkdir -p $out/share/applications $out/share/kde4/services
    install -m444 "$src/lib/xdg/telegramdesktop.desktop" "$out/share/applications/telegram-desktop.desktop"
    sed "s,/usr/bin,$out/bin,g" $archPatches/tg.protocol > $out/share/kde4/services/tg.protocol
    for icon_size in 16 32 48 64 128 256 512; do
      install -Dm644 "../../../Telegram/Resources/art/icon''${icon_size}.png" "$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps/telegram.png"
    done
  '';

  postFixup = ''
    # This is necessary to run Telegram in a pure environment.
    # We also use gappsWrapperArgs from wrapGAppsHook.
    wrapProgram $out/bin/telegram-desktop \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --prefix PATH : ${xdg_utils}/bin \
      --set XDG_RUNTIME_DIR "XDG-RUNTIME-DIR"
    sed -i $out/bin/telegram-desktop \
      -e "s,'XDG-RUNTIME-DIR',\"\''${XDG_RUNTIME_DIR:-/run/user/\$(id --user)}\","
  '';

  meta = {
    description = "Telegram Desktop messaging app";
    longDescription = ''
      Desktop client for the Telegram messenger, based on the Telegram API and
      the MTProto secure protocol.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = https://desktop.telegram.org/;
    maintainers = with maintainers; [ primeos abbradar ];
  };
}
