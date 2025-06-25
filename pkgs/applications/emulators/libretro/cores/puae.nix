{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-05-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "f1c248602abb58e7c570feec3f59f4677407b252";
    hash = "sha256-CmdMeAntu+uFp1HowBz3UgMiqFbRrNuMyevTlKxga/M=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
