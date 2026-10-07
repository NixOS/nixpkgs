{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pokemini";
  version = "0-unstable-2026-07-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "PokeMini";
    rev = "132111b76343559860532a1ccc094f93f1ed5650";
    hash = "sha256-Gyany/aEzDlhLM/zowsOU8LLI4FdWEQ83B+mxHX56UI=";
  };

  makefile = "Makefile";

  meta = {
    description = "Obscure nintendo handheld emulator";
    homepage = "https://github.com/libretro/PokeMini";
    license = lib.licenses.gpl3Only;
  };
}
