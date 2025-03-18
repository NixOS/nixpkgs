{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  crc32c,
  python3,
  libjpeg,
  openssl,
  libopus,
  ffmpeg,
  openh264,
  libvpx,
  libXi,
  libXfixes,
  libXtst,
  libXcomposite,
  libXdamage,
  libXext,
  libXrender,
  libXrandr,
  glib,
  abseil-cpp,
  pipewire,
  mesa,
  libGL,
  unstableGitUpdater,
  darwin,
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "0-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "c425281150317753d7bc5182c6572abe20f9a784";
    sha256 = "sha256-EHQyGE2S2F2UqNl7VDb38pcdv3amm8lGqWZds5ZoHRE=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs =
    [
      openssl
      libjpeg
      libopus
      ffmpeg
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib
      libXi
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrender
      libXrandr
      libXtst
      pipewire
      mesa
      libGL
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Cocoa
        AppKit
        IOKit
        IOSurface
        Foundation
        AVFoundation
        CoreMedia
        VideoToolbox
        CoreGraphics
        CoreVideo
        Metal
        MetalKit
        CoreFoundation
        ApplicationServices
      ]
    );

  propagatedBuildInputs = [
    abseil-cpp
    crc32c
    openh264
    libvpx
  ];

  cmakeFlags = [
    # Building as a shared library isn't officially supported and may break at any time.
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fork of Google's webrtc library for telegram-desktop";
    homepage = "https://github.com/desktop-app/tg_owt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oxalica ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
