{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "tgbdual";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "tgbdual-libretro";
    rev = "0392c9c469e653205e471114c7949c07c83bfce9";
    hash = "sha256-Wv4QsfhLckApBwK4PPiTpEeAbq3q1MwKXdYm44d+Ykk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of TGBDual to libretro";
    homepage = "https://github.com/libretro/tgbdual-libretro";
    license = lib.licenses.gpl2Only;
  };
}
