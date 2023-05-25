{ lib
, fetchFromGitHub
, fetchpatch
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
, webkitgtk_6_0
, jemalloc
, rnnoise
, protobuf
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
      cxxStandard = "20";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "telegram-desktop";
  version = "4.8.1";
  # Note: Update via pkgs/applications/networking/instant-messengers/telegram/tdesktop/update.py

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0mxxfh70dffkrq76nky3pwrk10s1q4ahxx2ddb58dz8igq6pl4zi";
  };

  patches = [
    # the generated .desktop files contains references to unwrapped tdesktop, breaking scheme handling
    # and the scheme handler is already registered in the packaged .desktop file, rendering this unnecessary
    # see https://github.com/NixOS/nixpkgs/issues/218370
    (fetchpatch {
      url = "https://salsa.debian.org/debian/telegram-desktop/-/raw/09b363ed5a4fcd8ecc3282b9bfede5fbb83f97ef/debian/patches/Disable-register-custom-scheme.patch";
      hash = "sha256-B8X5lnSpwwdp1HlvyXJWQPybEN+plOwimdV5gW6aY2Y=";
    })
  ];

  postPatch = ''
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioInputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioOutputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioPulse.cpp \
      --replace '"libpulse.so.0"' '"${libpulseaudio}/lib/libpulse.so.0"'
    substituteInPlace Telegram/lib_webview/webview/platform/linux/webview_linux_webkitgtk_library.cpp \
      --replace '"libwebkitgtk-6.0.so.4"' '"${webkitgtk_6_0}/lib/libwebkitgtk-6.0.so.4"'
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
    webkitgtk_6_0
    jemalloc
    rnnoise
    protobuf
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
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
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
