{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prboom";
  version = "0-unstable-2024-12-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-prboom";
    rev = "b3e5f8b2e8855f9c6fc7ff7a0036e4e61379177d";
    hash = "sha256-FtPn54s/QUu8fjeUBaAQMZ6EWAixV+gawuCv2eM+qrs=";
  };

  makefile = "Makefile";

  meta = {
    description = "Prboom libretro port";
    homepage = "https://github.com/libretro/libretro-prboom";
    license = lib.licenses.gpl2Only;
  };
}
