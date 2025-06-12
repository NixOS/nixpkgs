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
  version = "0-unstable-2025-06-06";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "8f033723a1b3437c8e3c8b42a92331eebe53ed0b";
    hash = "sha256-RrWBN8RDAS7RcIOouU3x2Pv/RKrshrmmmCZCeXQ6upk=";
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
