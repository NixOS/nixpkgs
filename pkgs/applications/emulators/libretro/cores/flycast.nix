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
  version = "0-unstable-2025-01-09";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "3114344414dbd8fb08efe1d6a25dbae457a2ec44";
    hash = "sha256-UgH8L02WkAPaMMUnes6GYLjRbkuY8+9b6LCGaaQWhjQ=";
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
