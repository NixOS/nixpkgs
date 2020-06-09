{ mkDerivation, lib, fetchurl, fetchsvn
, pkgconfig, cmake, ninja, python3, wrapGAppsHook, wrapQtAppsHook
, qtbase, qtimageformats, gtk3, libsForQt5, enchant2, lz4, xxHash
, dee, ffmpeg_4, openalSoft, minizip, libopus, alsaLib, libpulseaudio, range-v3
, tl-expected, hunspell
# TODO: Shouldn't be required:
, pcre, xorg, utillinux, libselinux, libsepol, epoxy, at-spi2-core, libXtst
, xdg_utils
}:

with lib;

# Main reference:
# - This package was originally based on the Arch package but all patches are now upstreamed:
#   https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/telegram-desktop
# Other references that could be useful:
# - https://git.alpinelinux.org/aports/tree/testing/telegram-desktop/APKBUILD
# - https://github.com/void-linux/void-packages/blob/master/srcpkgs/telegram-desktop/template

mkDerivation rec {
  pname = "telegram-desktop";
  version = "2.1.11";

  # Telegram-Desktop with submodules
  src = fetchurl {
    url = "https://github.com/telegramdesktop/tdesktop/releases/download/v${version}/tdesktop-${version}-full.tar.gz";
    sha256 = "1sd6nrcjg5gpq6ynvwnz8f4jz8flknybx6b0pfxqrqqpzy7wjl5m";
  };

  postPatch = ''
    substituteInPlace Telegram/lib_spellcheck/spellcheck/platform/linux/linux_enchant.cpp \
      --replace '"libenchant-2.so.2"' '"${enchant2}/lib/libenchant-2.so.2"'
    substituteInPlace Telegram/CMakeLists.txt \
      --replace '"''${TDESKTOP_LAUNCHER_BASENAME}.appdata.xml"' '"''${TDESKTOP_LAUNCHER_BASENAME}.metainfo.xml"'
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [ pkgconfig cmake ninja python3 wrapGAppsHook wrapQtAppsHook ];

  buildInputs = [
    qtbase qtimageformats gtk3 libsForQt5.libdbusmenu enchant2 lz4 xxHash
    dee ffmpeg_4 openalSoft minizip libopus alsaLib libpulseaudio range-v3
    tl-expected hunspell
    # TODO: Shouldn't be required:
    pcre xorg.libpthreadstubs xorg.libXdmcp utillinux libselinux libsepol epoxy at-spi2-core libXtst
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-Ddisable_autoupdate=ON"
    # TODO: Officiall API credentials for Nixpkgs
    # (see: https://github.com/NixOS/nixpkgs/issues/55271):
    "-DTDESKTOP_API_TEST=ON"
    "-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=OFF"
    "-DDESKTOP_APP_USE_PACKAGED_VARIANT=OFF"
    "-DDESKTOP_APP_USE_PACKAGED_GSL=OFF"
    "-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME=ON"
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
  # TODO: Package mapbox-variant

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
    homepage = "https://desktop.telegram.org/";
    changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v{version}";
    maintainers = with maintainers; [ primeos abbradar ];
  };
}
