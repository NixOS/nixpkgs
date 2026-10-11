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
  version = "0-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "59ed35a7ea7c1940d4c8ac221a662d0e6d6dc9ea";
    hash = "sha256-OOCPqiudFltQo1KMhFTp7qyU3jWiVlQ+wBK5ugbH9KQ=";
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
