{ mkDerivation, lib, fetchurl, fetchsvn
, pkgconfig, cmake, ninja, python3, wrapGAppsHook, wrapQtAppsHook
, qtbase, qtimageformats, gtk3, libappindicator-gtk3, enchant2, lz4, xxHash
, dee, ffmpeg_4, openalSoft, minizip, libopus, alsaLib, libpulseaudio, range-v3
# TODO: Shouldn't be required:
, pcre, xorg, utillinux, libselinux, libsepol, epoxy, at-spi2-core, libXtst
, xdg_utils
}:

with lib;

# Main reference:
# - This package is based on the Arch package:
#   https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/telegram-desktop
# Other references that could be useful (but we should try to stick to Arch):
# - https://git.alpinelinux.org/aports/tree/testing/telegram-desktop/APKBUILD
# - https://github.com/void-linux/void-packages/blob/master/srcpkgs/telegram-desktop/template

mkDerivation rec {
  pname = "telegram-desktop";
  version = "1.9.3";
  # Note: Due to our strong dependency on the Arch patches it's probably best
  # to also wait for the Arch update (especially if the patches don't apply).

  # Telegram-Desktop with submodules
  src = fetchurl {
    url = "https://github.com/telegramdesktop/tdesktop/releases/download/v${version}/tdesktop-${version}-full.tar.gz";
    sha256 = "1fx7v7j7iw4iywdbl89c5f1y74via61a0k20zrgjv5a0j4v6g76a";
  };

  # Arch patches (svn export telegram-desktop/trunk)
  archPatches = fetchsvn {
    url = "svn://svn.archlinux.org/community/telegram-desktop/trunk";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    rev = "549803";
    sha256 = "1py2a25wgpvx0n4kz383fj0jav1qdm8wqx5bdaygg6296r294czj";
  };

  # Note: It would be best if someone could get as many patches upstream as
  # possible (we currently depend a lot on custom patches...).
  patches = [
    "${archPatches}/0001-Dynamic-linking-system-libs.patch"
    "${archPatches}/0002-Dynamic-linking-system-qt.patch"
    "${archPatches}/0004-gtk3.patch"
    "${archPatches}/0005-Use-system-wide-fonts.patch"
    "${archPatches}/0006-Revert-Disable-DemiBold-fallback-for-Semibold.patch"
  ];

  postPatch = ''
    substituteInPlace Telegram/SourceFiles/platform/linux/linux_libs.cpp \
      --replace '"appindicator3"' '"${libappindicator-gtk3}/lib/libappindicator3.so"'
    substituteInPlace cmake/external/ranges/CMakeLists.txt \
      --replace "/usr/include" "${range-v3}/include"
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [ pkgconfig cmake ninja python3 wrapGAppsHook wrapQtAppsHook ];

  buildInputs = [
    qtbase qtimageformats gtk3 libappindicator-gtk3 enchant2 lz4 xxHash
    dee ffmpeg_4 openalSoft minizip libopus alsaLib libpulseaudio range-v3
    # TODO: Shouldn't be required:
    pcre xorg.libpthreadstubs xorg.libXdmcp utillinux libselinux libsepol epoxy at-spi2-core libXtst
  ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [
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

  cmakeFlags = [
    #"-DTDESKTOP_API_TEST=ON" # TODO: Officiall API credentials for Nixpkgs
    "-DTDESKTOP_API_ID=17349" # See: https://github.com/NixOS/nixpkgs/issues/55271
    "-DTDESKTOP_API_HASH=344583e45741c457fe1862106095a5eb"
    "-DDESKTOP_APP_USE_GLIBC_WRAPS=OFF"
    "-DDESKTOP_APP_USE_SYSTEM_LIBS=ON"
    "-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON"
    "-Ddisable_autoupdate=ON"
    "-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME=ON"
    "-DTDESKTOP_DISABLE_DESKTOP_FILE_GENERATION=ON"
    #"-DDESKTOP_APP_SPECIAL_TARGET=\"\"" # TODO: Error when set to "": Bad special target '""'
  ];

  installPhase = ''
    install -Dm755 bin/Telegram $out/bin/telegram-desktop

    mkdir -p $out/share/{kservices5,applications,metainfo}
    sed "s,/usr/bin,$out/bin,g" "../lib/xdg/tg.protocol" > "$out/share/kservices5/tg.protocol"
    install -m444 "../lib/xdg/telegramdesktop.desktop" "$out/share/applications/telegram-desktop.desktop"
    install -m644 "../lib/xdg/telegramdesktop.appdata.xml" "$out/share/metainfo/telegramdesktop.metainfo.xml"

    for icon_size in 16 32 48 64 128 256 512; do
      install -Dm644 "../Telegram/Resources/art/icon''${icon_size}.png" "$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps/telegram.png"
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
