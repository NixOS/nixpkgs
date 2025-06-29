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
  version = "0-unstable-2025-06-20";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "449d256995de36de0629dd1b97f4d67a0e50c92e";
    hash = "sha256-7+Dn7+AUnd3+eEKRMuahaxiEMWTT1uUEP2y0ZgIs81Q=";
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
