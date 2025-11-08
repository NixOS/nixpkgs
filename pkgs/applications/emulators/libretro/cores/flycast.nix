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
  version = "0-unstable-2025-10-18";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "5d628f8167947bc8a2a7608d52e4ff8b71b9ef34";
    hash = "sha256-QKUAVJsJL1Ff8KNz6lpMU/IZNb1I09++AqqccIBdAPw=";
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
