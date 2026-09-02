{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "quicknes";
  version = "0-unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "QuickNES_Core";
    rev = "26bb785c9deddb66a17717b21bb4e328f03ade32";
    hash = "sha256-0W6kYAnRw7uVdjoFL+f4Y8Ut932NbsoEer5TTwf9rBk=";
  };

  makefile = "Makefile";

  meta = {
    description = "QuickNES libretro port";
    homepage = "https://github.com/libretro/QuickNES_Core";
    license = lib.licenses.lgpl21Plus;
  };
}
