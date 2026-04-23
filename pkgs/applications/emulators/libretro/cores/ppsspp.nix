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
  libx11,
}:
mkLibretroCore {
  core = "ppsspp";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
    rev = "93601fe4a065ae25993047cc85de452b42b61c6e";
    hash = "sha256-nBC1VTfGlGteYjElIPSCWXljzynoKAVhHgELhRK5a1o=";
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
    libx11
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
