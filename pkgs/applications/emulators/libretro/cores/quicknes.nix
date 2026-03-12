{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "quicknes";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "QuickNES_Core";
    rev = "dbf19f73e3eb9701d1c7f5898f57c097e05c9fbd";
    hash = "sha256-oFQUMp1imc8JCsQYCy1BtIUmTC+u0VcoYHpWzUpKNb4=";
  };

  makefile = "Makefile";

  meta = {
    description = "QuickNES libretro port";
    homepage = "https://github.com/libretro/QuickNES_Core";
    license = lib.licenses.lgpl21Plus;
  };
}
