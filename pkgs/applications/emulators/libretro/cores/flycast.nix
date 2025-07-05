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
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "3f79b6baed2eebbf133b950197c418de06f28916";
    hash = "sha256-C4Q9jTS5UcnwiP7i+Ka4CH2S+dXLbm2vwS93955/RoY=";
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
