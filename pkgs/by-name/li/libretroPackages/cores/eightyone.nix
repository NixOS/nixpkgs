{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "81";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "81-libretro";
    rev = "fa7094910d040baa5fd8b11dbf6a1a618330ecd9";
    hash = "sha256-TuAx8frehC9h+s77xcigydMxvHXLzIc/q1y4vK8/WuI=";
  };

  meta = {
    description = "Port of EightyOne to libretro";
    homepage = "https://github.com/libretro/81-libretro";
    license = lib.licenses.gpl3Only;
  };
}
