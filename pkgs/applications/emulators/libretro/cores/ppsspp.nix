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
<<<<<<< HEAD
  version = "0-unstable-2025-12-30";
=======
  version = "0-unstable-2025-11-27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
<<<<<<< HEAD
    rev = "34fde065b76805c851d7c4b5bc4c67a3d347aab9";
    hash = "sha256-se8WptzipVwAE6Qwq2hTv7xBsY22HoACdVrPv+ssBDc=";
=======
    rev = "e5bafa4264e88cf2699e44740e2580ced0454a90";
    hash = "sha256-+Rmj75yBodwqENJppTWpsef9R0ajCoz9KaxVuYktUII=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
