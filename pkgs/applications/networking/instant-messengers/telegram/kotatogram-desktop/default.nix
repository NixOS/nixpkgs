{ lib
, stdenv
, fetchFromGitHub
, callPackage
, pkg-config
, cmake
, ninja
, clang
, python3
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
, jemalloc
, rnnoise
, abseil-cpp
, microsoft_gsl
, wayland
, libicns
, Cocoa
, CoreFoundation
, CoreServices
, CoreText
, CoreGraphics
, CoreMedia
, OpenGL
, AudioUnit
, ApplicationServices
, Foundation
, AGL
, Security
, SystemConfiguration
, Carbon
, AudioToolbox
, VideoToolbox
, VideoDecodeAcceleration
, AVFoundation
, CoreAudio
, CoreVideo
, CoreMediaIO
, QuartzCore
, AppKit
, CoreWLAN
, WebKit
, IOKit
, GSS
, MediaPlayer
, IOSurface
, Metal
, MetalKit
}:

let
  tg_owt = callPackage ./tg_owt.nix {
    abseil-cpp = (abseil-cpp.override {
      # abseil-cpp should use the same compiler
      inherit stdenv;
      cxxStandard = "20";
    }).overrideAttrs (_: {
      # https://github.com/NixOS/nixpkgs/issues/130963
      NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lc++abi";
    });

    # tg_owt should use the same compiler
    inherit stdenv;

    inherit Cocoa AppKit IOKit IOSurface Foundation AVFoundation CoreMedia VideoToolbox
      CoreGraphics CoreVideo OpenGL Metal MetalKit CoreFoundation ApplicationServices;
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
    ./kf594.patch
    ./shortcuts-binary-path.patch
    # let it build with nixpkgs 10.12 sdk
    ./kotato-10.12-sdk.patch
  ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioInputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioOutputALSA.cpp \
      --replace '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioPulse.cpp \
      --replace '"libpulse.so.0"' '"${libpulseaudio}/lib/libpulse.so.0"'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Telegram/CMakeLists.txt \
      --replace 'COMMAND iconutil' 'COMMAND png2icns' \
      --replace '--convert icns' "" \
      --replace '--output AppIcon.icns' 'AppIcon.icns' \
      --replace "\''${appicon_path}" "\''${appicon_path}/icon_16x16.png \''${appicon_path}/icon_32x32.png \''${appicon_path}/icon_128x128.png \''${appicon_path}/icon_256x256.png \''${appicon_path}/icon_512x512.png"
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3
    wrapQtAppsHook
    removeReferencesTo
  ] ++ lib.optionals stdenv.isLinux [
    # to build bundled libdispatch
    clang
    extra-cmake-modules
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
    microsoft_gsl
  ] ++ lib.optionals stdenv.isLinux [
    kwayland
    alsa-lib
    libpulseaudio
    hunspell
    glibmm
    jemalloc
    wayland
  ] ++ lib.optionals stdenv.isDarwin [
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
    libicns
  ];

  # https://github.com/NixOS/nixpkgs/issues/130963
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lc++abi";

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DTDESKTOP_API_TEST=ON"
    "-DDESKTOP_APP_QT6=OFF"
  ];

  installPhase = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r Kotatogram.app $out/Applications
    ln -s $out/Applications/Kotatogram.app/Contents/MacOS $out/bin
  '';

  preFixup = ''
    binName=${if stdenv.isLinux then "kotatogram-desktop" else "Kotatogram"}
    remove-references-to -t ${stdenv.cc.cc} $out/bin/$binName
    remove-references-to -t ${microsoft_gsl} $out/bin/$binName
    remove-references-to -t ${tg_owt.dev} $out/bin/$binName
  '';

  passthru = {
    inherit tg_owt;
  };

  meta = with lib; {
    description = "Kotatogram – experimental Telegram Desktop fork";
    longDescription = ''
      Unofficial desktop client for the Telegram messenger, based on Telegram Desktop.

      It contains some useful (or purely cosmetic) features, but they could be unstable. A detailed list is available here: https://kotatogram.github.io/changes
    '';
    license = licenses.gpl3;
    platforms = platforms.all;
    homepage = "https://kotatogram.github.io";
    changelog = "https://github.com/kotatogram/kotatogram-desktop/releases/tag/k{version}";
    maintainers = with maintainers; [ ilya-fedin ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = (stdenv.isDarwin && stdenv.isAarch64) || (stdenv.isLinux && stdenv.isAarch64);
  };
}
