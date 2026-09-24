{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-09-20";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "e86e1f6f421b1101e6f1dfdec1545ebe7cbba3ec";
    hash = "sha256-oHTMnTF26yMsbvwQcazBwCn5AUz6n1uqRUVb/v8zaNY=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
