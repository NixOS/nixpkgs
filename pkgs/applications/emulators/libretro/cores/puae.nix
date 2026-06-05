{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-05-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "9fda5f344470d6837e17b939b0f53e5afe938878";
    hash = "sha256-gGuYxGRRGyBbHiyG7Gpoi2/frEI5d+ySo8JdZStznN8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
