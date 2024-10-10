{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, ninja
, yasm
, libjpeg
, openssl
, libopus
, ffmpeg
, protobuf
, openh264
, crc32c
, libvpx
, libX11
, libXtst
, libXcomposite
, libXdamage
, libXext
, libXrender
, libXrandr
, libXi
, glib
, abseil-cpp
, pipewire
, mesa
, libdrm
, libGL
, darwin
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "0-unstable-2024-06-15";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "c9cc4390ab951f2cbc103ff783a11f398b27660b";
    sha256 = "sha256-FfWmSYaeryTDbsGJT3R7YK1oiyJcrR7YKKBOF+9PmpY=";
    fetchSubmodules = true;
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/modules/desktop_capture/linux/wayland/egl_dmabuf.cc \
      --replace '"libEGL.so.1"' '"${libGL}/lib/libEGL.so.1"' \
      --replace '"libGL.so.1"' '"${libGL}/lib/libGL.so.1"' \
      --replace '"libgbm.so.1"' '"${mesa}/lib/libgbm.so.1"' \
      --replace '"libdrm.so.2"' '"${libdrm}/lib/libdrm.so.2"'
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  propagatedBuildInputs = [
    libjpeg
    openssl
    libopus
    ffmpeg
    protobuf
    openh264
    crc32c
    libvpx
    abseil-cpp
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
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
  ]);

  enableParallelBuilding = true;

  meta.license = lib.licenses.bsd3;
}
