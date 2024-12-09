{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2024-10-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "3eeb65e9bcf4b2a7ca24c5cebdfa7e342177ef0f";
    hash = "sha256-tNGMR6GIyXen9+Ktg3IvYTcPidc+5Z8TpBQu1YgmqlY=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
