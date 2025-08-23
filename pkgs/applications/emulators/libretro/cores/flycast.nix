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
  version = "0-unstable-2025-08-20";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "9c5408a6d3fff939ae06a319c2fce3aa6f2a4d69";
    hash = "sha256-AH/XVN7Ah2DzN8/jlagOEAsNSciQMf8WBhfdC7YIMHw=";
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
