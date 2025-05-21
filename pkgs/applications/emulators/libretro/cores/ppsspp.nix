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
  version = "0-unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
    rev = "732d05c2c136856a3f173574233a2431a015a6f5";
    hash = "sha256-5PVN8qG0ONsro6jH/8rAIma+4DlKAUoS/6aUPqBqbe4=";
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
