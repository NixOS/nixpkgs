{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
, ninja
, yasm
, libjpeg
, openssl
, libopus
, ffmpeg_4
, protobuf
, openh264
, usrsctp
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
, Cocoa
, AppKit
, IOKit
, IOSurface
, Foundation
, AVFoundation
, CoreMedia
, VideoToolbox
, CoreGraphics
, CoreVideo
, OpenGL
, Metal
, MetalKit
, CoreFoundation
, ApplicationServices
}:

let
  libsrtp = fetchFromGitHub {
    owner = "cisco";
    repo = "libsrtp";

    # https://github.com/desktop-app/tg_owt/commit/6894e86eef8809d42b66eb85e376006f2a816a56
    rev = "a566a9cfcd619e8327784aa7cff4a1276dc1e895";
    sha256 = "sha256-OvCw7oF1OuamP3qO2BsimeBSHq1rcXFLfK8KnbbgkMU=";
  };
in

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "unstable-2022-04-13";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "63a934db1ed212ebf8aaaa20f0010dd7b0d7b396";
    sha256 = "sha256-WddSsQ9KW1zYyYckzdUOvfFZArYAbyvXmABQNMtK6cM=";
    fetchSubmodules = true;
  };

  patches = [
    ./tg_owt.patch

    (fetchpatch {
      url = "https://github.com/desktop-app/tg_owt/commit/0614aac699b1a53242ffe2664e3724533bf64f97.patch";
      hash = "sha256-iCdX518CB/RboDFhl3opnwcAgtqpNWZzYtV75Q+WB6Y=";
    })

    (fetchpatch {
      url = "https://github.com/desktop-app/tg_owt/commit/9d120195334db4f232c925529aa7601656dc59d7.patch";
      hash = "sha256-k99OBCdE2eQVyXEyvreEqVtzC8Xfdolbgd1Z7lV2ceE=";
    })
  ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace src/modules/desktop_capture/linux/egl_dmabuf.cc \
      --replace '"libEGL.so.1"' '"${libGL}/lib/libEGL.so.1"' \
      --replace '"libGL.so.1"' '"${libGL}/lib/libGL.so.1"' \
      --replace '"libgbm.so.1"' '"${mesa}/lib/libgbm.so.1"' \
      --replace '"libdrm.so.2"' '"${libdrm}/lib/libdrm.so.2"'

    rm -r src/third_party/libsrtp
    cp -r --no-preserve=mode ${libsrtp} src/third_party/libsrtp
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  propagatedBuildInputs = [
    libjpeg
    openssl
    libopus
    ffmpeg_4
    protobuf
    openh264
    usrsctp
    libvpx
    abseil-cpp
  ] ++ lib.optionals stdenv.isLinux [
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
  ] ++ lib.optionals stdenv.isDarwin [
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
  ];

  enableParallelBuilding = true;

  meta.license = lib.licenses.bsd3;
}
