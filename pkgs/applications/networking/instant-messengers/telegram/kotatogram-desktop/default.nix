{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, callPackage
, pkg-config
, cmake
, ninja
, clang
, lld
, python3
, wrapQtAppsHook
, removeReferencesTo
, qtbase
, qtimageformats
, qtsvg
, qtwayland
, kcoreaddons
, lz4
, xxHash
, ffmpeg
, protobuf
, openalSoft
, minizip
, libopus
, alsa-lib
, libpulseaudio
, range-v3
, tl-expected
, hunspell
, gobject-introspection
, jemalloc
, rnnoise
, microsoft-gsl
, boost
, libicns
, darwin
}:

let
  tg_owt = callPackage ./tg_owt.nix {
    # tg_owt should use the same compiler
    inherit stdenv;
  };

  mainProgram = if stdenv.hostPlatform.isLinux then "kotatogram-desktop" else "Kotatogram";
in
stdenv.mkDerivation rec {
  pname = "kotatogram-desktop";
  version = "1.4.9-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "kotatogram";
    repo = "kotatogram-desktop";
    rev = "0581eb6219343b3cfcbb81124b372df1039b7568";
    hash = "sha256-rvn8GZmHdMkVutLUe/LmUNIawlb9VgU3sYhPwZ2MWsI=";
    fetchSubmodules = true;
  };

  patches = [
    ./macos.patch
    ./macos-opengl.patch
    ./macos-qt5.patch
    (fetchpatch {
      url = "https://gitlab.com/mnauw/cppgir/-/commit/c8bb1c6017a6f7f2e47bd10543aea6b3ec69a966.patch";
      stripLen = 1;
      extraPrefix = "cmake/external/glib/cppgir/";
      hash = "sha256-8B4h3BTG8dIlt3+uVgBI569E9eCebcor9uohtsrZpnI=";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioInputALSA.cpp \
      --replace-fail '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioOutputALSA.cpp \
      --replace-fail '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioPulse.cpp \
      --replace-fail '"libpulse.so.0"' '"${libpulseaudio}/lib/libpulse.so.0"'
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Telegram/lib_webrtc/webrtc/platform/mac/webrtc_environment_mac.mm \
      --replace-fail kAudioObjectPropertyElementMain kAudioObjectPropertyElementMaster
  '';

  # Wrapping the inside of the app bundles, avoiding double-wrapping
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3
    wrapQtAppsHook
    removeReferencesTo
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    # to build bundled libdispatch
    clang
    gobject-introspection
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    lld
  ];

  buildInputs = [
    qtbase
    qtimageformats
    qtsvg
    lz4
    xxHash
    ffmpeg
    openalSoft
    minizip
    libopus
    range-v3
    tl-expected
    rnnoise
    tg_owt
    microsoft-gsl
    boost
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    protobuf
    qtwayland
    kcoreaddons
    alsa-lib
    libpulseaudio
    hunspell
    jemalloc
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    Cocoa
    CoreFoundation
    CoreServices
    CoreText
    CoreGraphics
    CoreMedia
    OpenGL
    AudioUnit
    ApplicationServices
    Foundation
    AGL
    Security
    SystemConfiguration
    Carbon
    AudioToolbox
    VideoToolbox
    VideoDecodeAcceleration
    AVFoundation
    CoreAudio
    CoreVideo
    CoreMediaIO
    QuartzCore
    AppKit
    CoreWLAN
    WebKit
    IOKit
    GSS
    MediaPlayer
    IOSurface
    Metal
    NaturalLanguage
    libicns
  ]);

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };

  cmakeFlags = [
    "-DTDESKTOP_API_TEST=ON"
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r ${mainProgram}.app $out/Applications
    ln -s $out/{Applications/${mainProgram}.app/Contents/MacOS,bin}
  '';

  preFixup = ''
    remove-references-to -t ${stdenv.cc.cc} $out/bin/${mainProgram}
    remove-references-to -t ${microsoft-gsl} $out/bin/${mainProgram}
    remove-references-to -t ${tg_owt.dev} $out/bin/${mainProgram}
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    wrapQtApp $out/Applications/${mainProgram}.app/Contents/MacOS/${mainProgram}
  '';

  passthru = {
    inherit tg_owt;
  };

  meta = with lib; {
    inherit mainProgram;
    description = "Kotatogram – experimental Telegram Desktop fork";
    longDescription = ''
      Unofficial desktop client for the Telegram messenger, based on Telegram Desktop.

      It contains some useful (or purely cosmetic) features, but they could be unstable. A detailed list is available here: https://kotatogram.github.io/changes
    '';
    license = licenses.gpl3Only;
    platforms = platforms.all;
    homepage = "https://kotatogram.github.io";
    changelog = "https://github.com/kotatogram/kotatogram-desktop/releases/tag/k{version}";
    maintainers = with maintainers; [ ilya-fedin ];
  };
}
