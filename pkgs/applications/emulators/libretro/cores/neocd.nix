{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "neocd";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "neocd_libretro";
    rev = "9216ca226f24e01e77fc2670035e97da154f3de4";
    hash = "sha256-Mq9UOuPwmG2Di68jWUgCbBvG3jUCEMON8Kfly/aCdH4=";
  };

  makefile = "Makefile";

  meta = {
    description = "NeoCD libretro port";
    homepage = "https://github.com/libretro/neocd_libretro";
    license = lib.licenses.lgpl3Only;
  };
}
