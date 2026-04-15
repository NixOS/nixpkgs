{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prosystem";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "prosystem-libretro";
    rev = "980edb381b0bf9ea7992caab24039a537aeb510e";
    hash = "sha256-uuh5YLKHW5aVe01GH12TqAlSp83s/PF/8Mlw105HIJg=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of ProSystem to libretro";
    homepage = "https://github.com/libretro/prosystem-libretro";
    license = lib.licenses.gpl2Only;
  };
}
