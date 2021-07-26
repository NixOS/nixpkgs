{ mkDerivation, lib, fetchFromGitHub, callPackage, fetchpatch
, pkg-config, cmake, ninja, python3, wrapGAppsHook, wrapQtAppsHook
, extra-cmake-modules
, qtbase, qtimageformats, gtk3, libsForQt5, lz4, xxHash
, ffmpeg, openalSoft, minizip, libopus, alsa-lib, libpulseaudio, range-v3
, tl-expected, hunspell, glibmm, webkitgtk, jemalloc
, rnnoise
# Transitive dependencies:
, util-linuxMinimal
, pcre, libpthreadstubs, libXdmcp, libselinux, libsepol, epoxy
, at-spi2-core, libXtst, libthai, libdatrie
, xdg-utils, libsysprof-capture, libpsl, brotli
}:

with lib;

# Main reference:
# - This package was originally based on the Arch package but all patches are now upstreamed:
#   https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/telegram-desktop
# Other references that could be useful:
# - https://git.alpinelinux.org/aports/tree/testing/telegram-desktop/APKBUILD
# - https://github.com/void-linux/void-packages/blob/master/srcpkgs/telegram-desktop/template

let
  tg_owt = callPackage ./tg_owt.nix {};
in mkDerivation rec {
  pname = "telegram-desktop";
  version = "2.8.11";
  # Note: Update via pkgs/applications/networking/instant-messengers/telegram/tdesktop/update.py

  # Telegram-Desktop with submodules
  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "020ycgb77vx7rza590i3csrvq1zgm15rvpxqqcp0xkb4yh71i3hb";
  };

  patches = [(fetchpatch {
    # ref: https://github.com/desktop-app/lib_webview/pull/9
    url = "https://github.com/desktop-app/lib_webview/commit/75e924934eee8624020befbef1f3cb5b865d3b86.patch";
    sha256 = "sha256-rN4FVK4KT+xNf9IVdcpbxMqT0+t3SINJPRRQPyMiDP0=";
    stripLen = 1;
    extraPrefix = "Telegram/lib_webview/";
  })];

  postPatch = ''
    substituteInPlace Telegram/CMakeLists.txt \
      --replace '"''${TDESKTOP_LAUNCHER_BASENAME}.appdata.xml"' '"''${TDESKTOP_LAUNCHER_BASENAME}.metainfo.xml"'

    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioInputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioOutputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioPulse.cpp \
      --replace '"libpulse.so.0"' '"${libpulseaudio}/lib/libpulse.so.0"'
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config cmake ninja python3 wrapGAppsHook wrapQtAppsHook
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase qtimageformats gtk3 libsForQt5.kwayland libsForQt5.libdbusmenu lz4 xxHash
    ffmpeg openalSoft minizip libopus alsa-lib libpulseaudio range-v3
    tl-expected hunspell glibmm webkitgtk jemalloc
    rnnoise
    tg_owt
    # Transitive dependencies:
    util-linuxMinimal # Required for libmount thus not nativeBuildInputs.
    pcre libpthreadstubs libXdmcp libselinux libsepol epoxy
    at-spi2-core libXtst libthai libdatrie libsysprof-capture libpsl brotli
  ];

  cmakeFlags = [
    "-Ddisable_autoupdate=ON"
    # We're allowed to used the API ID of the Snap package:
    "-DTDESKTOP_API_ID=611335"
    "-DTDESKTOP_API_HASH=d524b414d21f4d37f08684c1df41ac9c"
    # See: https://github.com/NixOS/nixpkgs/pull/130827#issuecomment-885212649
    "-DDESKTOP_APP_USE_PACKAGED_FONTS=OFF"
  ];

  postFixup = ''
    # This is necessary to run Telegram in a pure environment.
    # We also use gappsWrapperArgs from wrapGAppsHook.
    wrapProgram $out/bin/telegram-desktop \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --prefix PATH : ${xdg-utils}/bin \
      --set XDG_RUNTIME_DIR "XDG-RUNTIME-DIR"
    sed -i $out/bin/telegram-desktop \
      -e "s,'XDG-RUNTIME-DIR',\"\''${XDG_RUNTIME_DIR:-/run/user/\$(id --user)}\","
  '';

  passthru = {
    inherit tg_owt;
    updateScript = ./update.py;
  };

  meta = {
    description = "Telegram Desktop messaging app";
    longDescription = ''
      Desktop client for the Telegram messenger, based on the Telegram API and
      the MTProto secure protocol.
    '';
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    homepage = "https://desktop.telegram.org/";
    changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v${version}";
    maintainers = with maintainers; [ primeos abbradar oxalica ];
  };
}
