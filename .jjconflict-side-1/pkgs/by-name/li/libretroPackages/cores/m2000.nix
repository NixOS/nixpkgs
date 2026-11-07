{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "m2000";
  version = "0-unstable-2026-08-21";

  src = fetchFromGitHub {
    owner = "p2000t";
    repo = "M2000";
    rev = "da0b8cbef2007c907f5db2166847c3209643865d";
    hash = "sha256-GxWUMJgEvz6p3JYRJ2Xo02HHupo+hT/noc7pwzjMUNE=";
  };

  sourceRoot = "source/src/libretro";
  makefile = "Makefile";

  meta = {
    description = "Philips P2000T emulator core for libretro";
    homepage = "https://github.com/p2000t/M2000";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
