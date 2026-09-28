{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mesen";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mesen";
    rev = "0102910c39ad1a62bc3f784466f3f67ca9eae335";
    hash = "sha256-fDGG6U+yhpbcvKuSN30F0dM+NCXlPTPULNEqTZTL/Vc=";
  };

  makefile = "Makefile";
  preBuild = "cd Libretro";

  meta = {
    description = "Port of Mesen to libretro";
    homepage = "https://github.com/libretro/mesen";
    license = lib.licenses.gpl3Only;
  };
}
