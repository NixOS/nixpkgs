{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gme";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-gme";
    rev = "818629a9fbb9f99bd9c585395318834ae5c6434e";
    hash = "sha256-+96uM0j0EG2mN52gpK26d12bTbvSj90rntg7+3LdX5A=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of blargg's Game_Music_Emu library";
    homepage = "https://github.com/libretro/libretro-gme";
    license = lib.licenses.gpl3Only;
  };
}
