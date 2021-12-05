{ lib
, stdenv
, fetchFromGitHub
, callPackage
, pkg-config
, cmake
, ninja
, clang
, python3
, wrapGAppsHook
, wrapQtAppsHook
, removeReferencesTo
, extra-cmake-modules
, qtbase
, qtimageformats
, qtsvg
, kwayland
, lz4
, xxHash
, ffmpeg
, openalSoft
, minizip
, libopus
, alsa-lib
, libpulseaudio
, range-v3
, tl-expected
, hunspell
, glibmm
, webkitgtk
, jemalloc
, rnnoise
, abseil-cpp
, microsoft_gsl
, wayland
, withWebKit ? false
}:

with lib;

let
  tg_owt = callPackage ./tg_owt.nix {
    abseil-cpp = abseil-cpp.override {
      cxxStandard = "20";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "kotatogram-desktop";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "kotatogram";
    repo = "kotatogram-desktop";
    rev = "k${version}";
    sha256 = "sha256-6bF/6fr8mJyyVg53qUykysL7chuewtJB8E22kVyxjHw=";
    fetchSubmodules = true;
  };

  patches = [
    ./shortcuts-binary-path.patch
  ];

  postPatch = ''
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioInputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioOutputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioPulse.cpp \
      --replace '"libpulse.so.0"' '"${libpulseaudio}/lib/libpulse.so.0"'
  '' + optionalString withWebKit ''
    substituteInPlace Telegram/lib_webview/webview/platform/linux/webview_linux_webkit_gtk.cpp \
      --replace '"libwebkit2gtk-4.0.so.37"' '"${webkitgtk}/lib/libwebkit2gtk-4.0.so.37"'
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = withWebKit;

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    # to build bundled libdispatch
    clang
    python3
    wrapQtAppsHook
    removeReferencesTo
    extra-cmake-modules
  ] ++ optionals withWebKit [
    wrapGAppsHook
  ];

  buildInputs = [
    qtbase
    qtimageformats
    qtsvg
    kwayland
    lz4
    xxHash
    ffmpeg
    openalSoft
    minizip
    libopus
    alsa-lib
    libpulseaudio
    range-v3
    tl-expected
    hunspell
    glibmm
    jemalloc
    rnnoise
    tg_owt
    microsoft_gsl
    wayland
  ] ++ optionals withWebKit [
    webkitgtk
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DTDESKTOP_API_TEST=ON"
    "-DDESKTOP_APP_QT6=OFF"
  ];

  preFixup = ''
    remove-references-to -t ${stdenv.cc.cc} $out/bin/kotatogram-desktop
    remove-references-to -t ${microsoft_gsl} $out/bin/kotatogram-desktop
    remove-references-to -t ${tg_owt.dev} $out/bin/kotatogram-desktop
  '';

  postFixup = optionalString withWebKit ''
    # We also use gappsWrapperArgs from wrapGAppsHook.
    wrapProgram $out/bin/kotatogram-desktop \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}"
  '';

  passthru = {
    inherit tg_owt;
  };

  meta = {
    description = "Kotatogram – experimental Telegram Desktop fork";
    longDescription = ''
      Unofficial desktop client for the Telegram messenger, based on Telegram Desktop.

      It contains some useful (or purely cosmetic) features, but they could be unstable. A detailed list is available here: https://kotatogram.github.io/changes
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "https://kotatogram.github.io";
    changelog = "https://github.com/kotatogram/kotatogram-desktop/releases/tag/k{version}";
    maintainers = with maintainers; [ ilya-fedin ];
  };
}
