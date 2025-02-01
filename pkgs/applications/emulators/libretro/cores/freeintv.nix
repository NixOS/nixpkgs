{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "beab9af119fc117833d2d866d8d4ea0857ec0236";
    hash = "sha256-+3hF7OZ2OD8K3OsvzJ3+Nn3DwC7PfD+Mr3Ku2/W/fDQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
