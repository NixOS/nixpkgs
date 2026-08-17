{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pokemini";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "PokeMini";
    rev = "bb009b1379ad15f1514f20ca7cbf710b4af42b3e";
    hash = "sha256-iXHUk0gWciJCKfbfIa2pOBPIOeKg1yRahNKesLRC8v8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Obscure nintendo handheld emulator";
    homepage = "https://github.com/libretro/PokeMini";
    license = lib.licenses.gpl3Only;
  };
}
