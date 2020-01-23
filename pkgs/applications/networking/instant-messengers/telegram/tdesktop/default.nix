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
  version = "1.9.7";
  # Note: Due to our strong dependency on the Arch patches it's probably best
  # to also wait for the Arch update (especially if the patches don't apply).

  # Telegram-Desktop with submodules
  src = fetchurl {
    url = "https://github.com/telegramdesktop/tdesktop/releases/download/v${version}/tdesktop-${version}-full.tar.gz";
    sha256 = "1hj7bv11alc8cfffy0k3za4missdr44cdmia93xn77w012qjn8a4";
  };

  # Arch patches (svn export telegram-desktop/trunk)
  archPatches = fetchsvn {
    url = "svn://svn.archlinux.org/community/telegram-desktop/trunk";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    rev = "554983";
    sha256 = "02gk5dlrmxvyl7w1yxmwclknk1k9drpx6rxqc6vmmw85l763m95j";
  };

  # Note: It would be best if someone could get as many patches upstream as
  # possible (we currently depend a lot on custom patches...).
  patches = [
    "${archPatches}/0005-Use-system-wide-fonts.patch"
  ];

  postPatch = ''
    substituteInPlace Telegram/SourceFiles/platform/linux/linux_libs.cpp \
      --replace '"appindicator3"' '"${libappindicator-gtk3}/lib/libappindicator3.so"'
    substituteInPlace Telegram/lib_spellcheck/spellcheck/platform/linux/linux_enchant.cpp \
      --replace '"libenchant-2.so.2"' '"${enchant2}/lib/libenchant-2.so.2"'
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
    "-Ddisable_autoupdate=ON"
    #"-DTDESKTOP_API_TEST=ON" # TODO: Officiall API credentials for Nixpkgs
    "-DTDESKTOP_API_ID=17349" # See: https://github.com/NixOS/nixpkgs/issues/55271
    "-DTDESKTOP_API_HASH=344583e45741c457fe1862106095a5eb"
    "-DDESKTOP_APP_USE_GLIBC_WRAPS=OFF"
    "-DDESKTOP_APP_USE_PACKAGED=ON"
    "-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=OFF"
    "-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON"
    "-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME=ON"
    "-DTDESKTOP_DISABLE_DESKTOP_FILE_GENERATION=ON"
    "-DTDESKTOP_USE_PACKAGED_TGVOIP=OFF"
    #"-DDESKTOP_APP_SPECIAL_TARGET=\"\"" # TODO: Error when set to "": Bad special target '""'
    "-DTDESKTOP_LAUNCHER_BASENAME=telegramdesktop" # Note: This is the default
  ];

  # Note: The following packages could be packaged system-wide, but it's
  # probably best to use the bundled ones from tdesktop (Arch does this too):
  # rlottie:
  # - CMake flag: "-DTDESKTOP_USE_PACKAGED_TGVOIP=ON"
  # - Sources (problem: there are no stable releases!):
  #   - desktop-app (tdesktop): https://github.com/desktop-app/rlottie
  #   - upstream: https://github.com/Samsung/rlottie
  # libtgvoip:
  # - CMake flag: "-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=ON"
  # - Sources  (problem: the stable releases might be too old!):
  #   - tdesktop: https://github.com/telegramdesktop/libtgvoip
  #   - upstream: https://github.com/grishka/libtgvoip
  # Both of these packages are included in this PR (kotatogram-desktop):
  # https://github.com/NixOS/nixpkgs/pull/75210

  installPhase = ''
    install -Dm755 bin/telegram-desktop $out/bin/telegram-desktop

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
      --set XDG_RUNTIME_DIR "XDG-RUNTIME-DIR" \
      --unset QT_QPA_PLATFORMTHEME # From the Arch wrapper
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
