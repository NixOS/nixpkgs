{
  lib,
  fetchFromGitHub,
  libGL,
  libGLU,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vecx";
  version = "0-unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-vecx";
    rev = "841229a6a81a0461d08af6488f252dcec5266c6a";
    hash = "sha256-bWhXXJCf/ax7n/sOfXibGvcFnCnmULcALoBR1uyIN+I=";
  };

  extraBuildInputs = [
    libGL
    libGLU
  ];

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/libretro-vecx";
    license = lib.licenses.gpl3Only;
  };
}
