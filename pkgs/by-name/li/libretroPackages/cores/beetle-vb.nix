{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-vb";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-vb-libretro";
    rev = "83ed42608601fb7b01d41e4f8fb2007a37b8c84e";
    hash = "sha256-ctjoQHdrZdb0QVxEpcsfhbqYrNp5R8oaC6xNrYxBG7g=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's VirtualBoy core to libretro";
    homepage = "https://github.com/libretro/beetle-vb-libretro";
    license = lib.licenses.gpl2Only;
  };
}
