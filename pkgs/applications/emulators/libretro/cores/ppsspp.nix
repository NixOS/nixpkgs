{
  lib,
  cmake,
  fetchFromGitHub,
  libGL,
  libGLU,
  libzip,
  mkLibretroCore,
  pkg-config,
  python3,
  snappy,
  xorg,
}:
mkLibretroCore {
  core = "ppsspp";
  version = "0-unstable-2026-01-10";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
    rev = "3f3b353350aae4f9584070c793bf19983886d910";
    hash = "sha256-VFAs6bmMWRn737nfRd98vcFJkVQ6Z580COUmgl2aOY0=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];
  extraBuildInputs = [
    libGLU
    libGL
    libzip
    snappy
    xorg.libX11
  ];
  makefile = "Makefile";
  cmakeFlags = [
    "-DLIBRETRO=ON"
    # USE_SYSTEM_FFMPEG=ON causes several glitches during video playback
    # See: https://github.com/NixOS/nixpkgs/issues/304616
    "-DUSE_SYSTEM_FFMPEG=OFF"
    "-DUSE_SYSTEM_SNAPPY=ON"
    "-DUSE_SYSTEM_LIBZIP=ON"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];
  postBuild = "cd lib";

  meta = {
    description = "PPSSPP libretro port";
    homepage = "https://github.com/hrydgard/ppsspp";
    license = lib.licenses.gpl2Plus;
    badPlatforms = [
      # error: cannot convert 'uint32x4_t' to 'int' in initialization
      "aarch64-linux"
    ];
  };
}
