{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-11-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "0043cf9c061bd9b81dbc1869c2761017139cfc63";
    hash = "sha256-xi/7zT+4LNfSMwfA+rvxdvsgpQRHceK6Heqrcy84RVk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
