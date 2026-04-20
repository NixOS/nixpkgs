{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  libGLU,
  libGL,
}:
mkLibretroCore {
  core = "melonds";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "melonds";
    rev = "e548eba517ccb964ddba31dcf8f0136041f5bb05";
    hash = "sha256-4bCunBPpBP0RWwL1vUTQxLPtCBnQ0M5pC3GAX1uTL5A=";
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
