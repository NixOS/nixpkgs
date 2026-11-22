{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  libGLU,
  libGL,
}:
mkLibretroCore {
  core = "melonds";
  version = "0-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "melonds";
    rev = "4081e8358e66f1ea11879560be6b813dfeaab75a";
    hash = "sha256-vFupodrFooyB0BKPOF3rt9fYCiARt9PJtojVRNb4GdQ=";
  };

  extraBuildInputs = [
    libGLU
    libGL
  ];
  makefile = "Makefile";

  meta = {
    description = "Port of MelonDS to libretro";
    homepage = "https://github.com/libretro/melonds";
    license = lib.licenses.gpl3Only;
  };
}
