{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "5ebe7d333ab15be57a9dde5f46c29a5bbd5f44f8";
    hash = "sha256-faDEBBp24kHphjHWh6enXxVfagBtAOx9eJc1xU++lIc=";
  };

  makefile = "Makefile";

  env = {
    EMUTYPE = "${type}";
  };

  meta = {
    description = "Port of vice to libretro";
    homepage = "https://github.com/libretro/vice-libretro";
    license = lib.licenses.gpl2;
  };
}
