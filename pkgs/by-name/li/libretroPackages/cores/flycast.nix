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
  version = "0-unstable-2026-10-17";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "6bb0fc3e18dac4b01694f488c7a71f5930e8a648";
    hash = "sha256-eMODbgbTHS35iTTBGy6ldgILkvGVibQ/HvfZlXDxDLI=";
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
