{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "99145bf34993e21dac14973f784821d85729a91d";
    hash = "sha256-VIg7e6St1qkQZafTmEMsIDZoWQLkqFZPRk4Cyr43wW8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
