{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  cmake,
  ninja,
  python3,
  libjpeg,
  openssl,
  libopus,
  ffmpeg,
  openh264,
  crc32c,
  libvpx,
  libX11,
  libXtst,
  libXcomposite,
  libXdamage,
  libXext,
  libXrender,
  libXrandr,
  libXi,
  glib,
  abseil-cpp,
  pipewire,
  mesa,
  libdrm,
  libGL,
  darwin,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "0-unstable-2024-08-04";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "dc17143230b5519f3c1a8da0079e00566bd4c5a8";
    hash = "sha256-7j7hBIOXEdNJDnDSVUqy234nkTCaeZ9tDAzqvcuaq0o=";
    fetchSubmodules = true;
  };

  patches = [
    # Remove usage of AVCodecContext::reordered_opaque
    (fetchpatch2 {
      name = "webrtc-ffmpeg-7.patch";
      url = "https://webrtc.googlesource.com/src/+/e7d10047096880feb5e9846375f2da54aef91202%5E%21/?format=TEXT";
      decode = "base64 -d";
      stripLen = 1;
      extraPrefix = "src/";
      hash = "sha256-EdwHeVko8uDsP5GTw2ryWiQgRVCAdPc1me6hySdiwMU=";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/modules/desktop_capture/linux/wayland/egl_dmabuf.cc \
      --replace-fail '"libEGL.so.1"' '"${lib.getLib libGL}/lib/libEGL.so.1"' \
      --replace-fail '"libGL.so.1"' '"${lib.getLib libGL}/lib/libGL.so.1"' \
      --replace-fail '"libgbm.so.1"' '"${lib.getLib mesa}/lib/libgbm.so.1"' \
      --replace-fail '"libdrm.so.2"' '"${lib.getLib libdrm}/lib/libdrm.so.2"'
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3
  ];

  propagatedBuildInputs =
    [
      libjpeg
      openssl
      libopus
      ffmpeg
      openh264
      crc32c
      libvpx
      abseil-cpp
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      libXtst
      libXcomposite
      libXdamage
      libXext
      libXrender
      libXrandr
      libXi
      glib
      pipewire
      mesa
      libdrm
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
        OpenGL
        Metal
        MetalKit
        CoreFoundation
        ApplicationServices
      ]
    );

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fork of Google's webrtc library for telegram-desktop";
    homepage = "https://github.com/desktop-app/tg_owt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oxalica ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
