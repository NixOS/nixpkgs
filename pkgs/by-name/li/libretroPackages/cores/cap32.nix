{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "cap32";
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-cap32";
    rev = "06ad0da5d003ab8f2359300ebce4cf31d4c55b6e";
    hash = "sha256-nw7DOXs0Jkm/vNNYmQ3UoqguiQVkxg+Qp8HT/uDHXnA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Caprice32 libretro port (Amstrad CPC emulator)";
    homepage = "https://github.com/libretro/libretro-cap32";
    license = lib.licenses.gpl2Only;
  };
}
