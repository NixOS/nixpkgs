{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fmsx";
  version = "0-unstable-2026-09-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fmsx-libretro";
    rev = "4de11755ce4f196ac1c8a7bb20bb4eccbc87a7d4";
    hash = "sha256-yv/NizFz6m7j6PVY+S6egN9837Dq8YGZ3AWk3sRdOmg=";
  };

  makefile = "Makefile";

  meta = {
    description = "FMSX libretro port";
    homepage = "https://github.com/libretro/fmsx-libretro";
    license = lib.licenses.unfreeRedistributable;
  };
}
