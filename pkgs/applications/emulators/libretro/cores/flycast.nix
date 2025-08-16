{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  cmake,
  libGL,
  libGLU,
}:
mkLibretroCore {
  core = "flycast";
  version = "0-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "40e400ab084175d3bd0f9e10cf8d6ac78c8b9544";
    hash = "sha256-k/w1tmuGuRD98bR/kmc/9pLFGeobHMhKQapJOv8qVJo=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [ cmake ];
  extraBuildInputs = [
    libGL
    libGLU
  ];
  cmakeFlags = [ "-DLIBRETRO=ON" ];
  makefile = "Makefile";

  meta = {
    description = "Flycast libretro port";
    homepage = "https://github.com/flyinghead/flycast";
    license = lib.licenses.gpl2Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
