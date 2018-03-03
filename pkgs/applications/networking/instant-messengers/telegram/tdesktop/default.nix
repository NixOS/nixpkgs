{ mkDerivation, lib, fetchgit, fetchpatch
, pkgconfig, gyp, cmake, makeWrapper
, qtbase, qtimageformats, gtk3, libappindicator-gtk3, libnotify
, dee, ffmpeg, openalSoft, minizip, libopus, alsaLib, libpulseaudio, range-v3
}:

mkDerivation rec {
  name = "telegram-desktop-${version}";
  version = "1.2.6";

  # Submodules
  src = fetchgit {
    url = "git://github.com/telegramdesktop/tdesktop";
    rev = "v${version}";
    sha256 = "15g0m2wwqfp13wd7j31p8cx1kpylx5m8ljaksnsqdkgyr9l1ar8w";
    fetchSubmodules = true;
  };

  # TODO: Not active anymore.
  tgaur = fetchgit {
    url = "https://aur.archlinux.org/telegram-desktop-systemqt.git";
    rev = "1ed27ce40913b9e6e87faf7a2310660c2790b98e";
    sha256 = "1i7ipqgisaw54g1nbg2cvpbx89g9gyjjb3sak1486pxsasp1qhyc";
  };

  patches = [
    (fetchpatch {
      name = "tdesktop.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/repos/community-x86_64/tdesktop.patch?h=packages/telegram-desktop&id=f0eefac36f529295f8b065a14b6d5f1a51d7614d";
      sha256 = "1a4wap5xnp6zn4913r3zdpy6hvkcfxcy4zzimy7fwzp7iwy20iqa";
    })
  ];

  postPatch = ''
    substituteInPlace Telegram/SourceFiles/platform/linux/linux_libs.cpp --replace '"appindicator"' '"${libappindicator-gtk3}/lib/libappindicator3.so"'
    substituteInPlace Telegram/SourceFiles/platform/linux/linux_libnotify.cpp --replace '"notify"' '"${libnotify}/lib/libnotify.so"'
  '';

  nativeBuildInputs = [ pkgconfig gyp cmake makeWrapper ];

  buildInputs = [
    qtbase qtimageformats gtk3 libappindicator-gtk3
    dee ffmpeg openalSoft minizip libopus alsaLib libpulseaudio range-v3
  ];

  enableParallelBuilding = true;

  GYP_DEFINES = lib.concatStringsSep "," [
    "TDESKTOP_DISABLE_CRASH_REPORTS"
    "TDESKTOP_DISABLE_AUTOUPDATE"
    "TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
  ];

  NIX_CFLAGS_COMPILE = [
    "-DTDESKTOP_DISABLE_AUTOUPDATE"
    "-DTDESKTOP_DISABLE_CRASH_REPORTS"
    "-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
    "-I${minizip}/include/minizip"
    # See Telegram/gyp/qt.gypi
    "-I${qtbase.dev}/mkspecs/linux-g++"
  ] ++ lib.concatMap (x: [
    "-I${qtbase.dev}/include/${x}"
    "-I${qtbase.dev}/include/${x}/${qtbase.version}"
    "-I${qtbase.dev}/include/${x}/${qtbase.version}/${x}"
    "-I${libopus.dev}/include/opus"
    "-I${alsaLib.dev}/include/alsa"
    "-I${libpulseaudio.dev}/include/pulse"
  ]) [ "QtCore" "QtGui" "QtDBus" ];
  CPPFLAGS = NIX_CFLAGS_COMPILE;

  preConfigure = ''

    pushd "Telegram/ThirdParty/libtgvoip"
    patch -Np1 -i "${tgaur}/libtgvoip.patch"
    popd

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

    gyp \
      -Dbuild_defines=${GYP_DEFINES} \
      -Gconfig=Release \
      --depth=Telegram/gyp \
      --generator-output=../.. \
      -Goutput_dir=out \
       --format=cmake \
      Telegram/gyp/Telegram.gyp

    cd out/Release

    NUM=$((`wc -l < CMakeLists.txt` - 2))
    sed -i "$NUM r $tgaur/CMakeLists.inj" CMakeLists.txt

    export ASM=$(type -p gcc)
  '';

  installPhase = ''
    install -Dm755 Telegram $out/bin/telegram-desktop
    mkdir -p $out/share/applications $out/share/kde4/services
    sed "s,/usr/bin,$out/bin,g" $tgaur/telegram-desktop.desktop > $out/share/applications/telegram-desktop.desktop
    sed "s,/usr/bin,$out/bin,g" $tgaur/tg.protocol > $out/share/kde4/services/tg.protocol
    for icon_size in 16 32 48 64 128 256 512; do
      install -Dm644 "../../../Telegram/Resources/art/icon''${icon_size}.png" "$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps/telegram-desktop.png"
    done

    # This is necessary to run Telegram in a pure environment.
    wrapProgram $out/bin/telegram-desktop \
      --prefix QT_PLUGIN_PATH : "${qtbase}/${qtbase.qtPluginPrefix}" \
      --set XDG_RUNTIME_DIR "XDG-RUNTIME-DIR"
    sed -i $out/bin/telegram-desktop \
      -e "s,'XDG-RUNTIME-DIR',\"\''${XDG_RUNTIME_DIR:-/run/user/\$(id --user)}\","
  '';

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = https://desktop.telegram.org/;
    maintainers = with maintainers; [ abbradar garbas primeos ];
  };
}
