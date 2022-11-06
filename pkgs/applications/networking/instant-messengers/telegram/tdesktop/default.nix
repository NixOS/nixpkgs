{ lib
, fetchFromGitHub
, callPackage
, pkg-config
, cmake
, ninja
, python3
, wrapGAppsHook
, wrapQtAppsHook
, extra-cmake-modules
, qtbase
, qtwayland
, qtsvg
, qtimageformats
, qt5compat
, gtk3
, libdbusmenu
, lz4
, xxHash
, ffmpeg
, openalSoft
, minizip
, libopus
, alsa-lib
, libpulseaudio
, pipewire
, range-v3
, tl-expected
, hunspell
, glibmm_2_68
, webkitgtk_4_1
, jemalloc
, rnnoise
, abseil-cpp
  # Transitive dependencies:
, util-linuxMinimal
, pcre
, libpthreadstubs
, libXdamage
, libXdmcp
, libselinux
, libsepol
, libepoxy
, at-spi2-core
, libXtst
, libthai
, libdatrie
, xdg-utils
, xorg
, libsysprof-capture
, libpsl
, brotli
, microsoft_gsl
, rlottie
, stdenv
, gcc10Stdenv
}:

# Main reference:
# - This package was originally based on the Arch package but all patches are now upstreamed:
#   https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/telegram-desktop
# Other references that could be useful:
# - https://git.alpinelinux.org/aports/tree/testing/telegram-desktop/APKBUILD
# - https://github.com/void-linux/void-packages/blob/master/srcpkgs/telegram-desktop/template

let
  tg_owt = callPackage ./tg_owt.nix {
    abseil-cpp = abseil-cpp.override {
      cxxStandard = "17";
    };
  };
  # Aarch64 default gcc9 will cause ICE. For reference #108305
  env = if stdenv.isAarch64 then gcc10Stdenv else stdenv;
in
env.mkDerivation rec {
  pname = "telegram-desktop";
  version = "4.3.0";
  # Note: Update via pkgs/applications/networking/instant-messengers/telegram/tdesktop/update.py

  # Telegram-Desktop with submodules
  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1ji9351vcvydkcrdwqx22j1nhl9vysd6ajvghaqxdirvqypiygj0";
  };

  postPatch = ''
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioInputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioOutputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioPulse.cpp \
      --replace '"libpulse.so.0"' '"${libpulseaudio}/lib/libpulse.so.0"'
    substituteInPlace Telegram/lib_webview/webview/platform/linux/webview_linux_webkit_gtk.cpp \
      --replace '"libwebkit2gtk-4.1.so.0"' '"${webkitgtk_4_1}/lib/libwebkit2gtk-4.1.so.0"'
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3
    wrapGAppsHook
    wrapQtAppsHook
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase
    qtwayland
    qtsvg
    qtimageformats
    qt5compat
    gtk3
    libdbusmenu
    lz4
    xxHash
    ffmpeg
    openalSoft
    minizip
    libopus
    alsa-lib
    libpulseaudio
    pipewire
    range-v3
    tl-expected
    hunspell
    glibmm_2_68
    webkitgtk_4_1
    jemalloc
    rnnoise
    tg_owt
    # Transitive dependencies:
    util-linuxMinimal # Required for libmount thus not nativeBuildInputs.
    pcre
    libpthreadstubs
    libXdamage
    libXdmcp
    libselinux
    libsepol
    libepoxy
    at-spi2-core
    libXtst
    libthai
    libdatrie
    libsysprof-capture
    libpsl
    brotli
    microsoft_gsl
    rlottie
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
      --prefix LD_LIBRARY_PATH : "${xorg.libXcursor}/lib" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --set XDG_RUNTIME_DIR "XDG-RUNTIME-DIR"
    sed -i $out/bin/telegram-desktop \
      -e "s,'XDG-RUNTIME-DIR',\"\''${XDG_RUNTIME_DIR:-/run/user/\$(id --user)}\","
  '';

  passthru = {
    inherit tg_owt;
    updateScript = ./update.py;
  };

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    longDescription = ''
      Desktop client for the Telegram messenger, based on the Telegram API and
      the MTProto secure protocol.
    '';
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    homepage = "https://desktop.telegram.org/";
    changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v${version}";
    maintainers = with maintainers; [ nickcao ];
  };
}
