{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-03-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "b26def5c5ab9ea35019a42b950e014a22907ea13";
    hash = "sha256-DoNYpEqlrWueh/rwB4pkPYPdkSi+EVxP5T6BPgqv1nU=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
