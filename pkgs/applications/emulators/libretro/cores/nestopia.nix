{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2024-10-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "b932740e8abbe2cda80d06b083fdd8115af1c5d5";
    hash = "sha256-lIWk3V93vTKZM/jvfLkA06c7DDSEQtLmqRzJUi0TK/4=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
