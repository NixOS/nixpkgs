{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  ninja,
  python3,
  libjpeg,
  openssl,
  libopus,
  ffmpeg_6,
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
  libgbm,
  libdrm,
  libGL,
  apple-sdk_15,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "0-unstable-2025-06-02";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "62321fd7128ab2650b459d4195781af8185e46b5";
    hash = "sha256-l6EdHJLd42TU+4pLakdU3a5PLVxrxjta0CSRy5hVBFU=";
    fetchSubmodules = true;
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/modules/desktop_capture/linux/wayland/egl_dmabuf.cc \
      --replace-fail '"libEGL.so.1"' '"${lib.getLib libGL}/lib/libEGL.so.1"' \
      --replace-fail '"libGL.so.1"' '"${lib.getLib libGL}/lib/libGL.so.1"' \
      --replace-fail '"libgbm.so.1"' '"${lib.getLib libgbm}/lib/libgbm.so.1"' \
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

  propagatedBuildInputs = [
    libjpeg
    openssl
    libopus
    ffmpeg_6
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
    libgbm
    libdrm
    libGL
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
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
