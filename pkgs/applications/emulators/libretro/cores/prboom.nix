{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prboom";
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-prboom";
    rev = "79d35037b742532e273b82088efad9c5c0af8a6d";
    hash = "sha256-BR1orEzjT8NQF59uPfHt6WlXwb23bDRnUV8F2itc/HM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Prboom libretro port";
    homepage = "https://github.com/libretro/libretro-prboom";
    license = lib.licenses.gpl2Only;
  };
}
