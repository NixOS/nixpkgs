{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nxengine";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nxengine-libretro";
    rev = "990bdaacd6ed9db735ea625c948252d0b8a2100a";
    hash = "sha256-41f2iHQi3gwla1gM2/rFvzTKhSIrJqYLZN+5f9Ylu7A=";
  };

  makefile = "Makefile";

  meta = {
    description = "NXEngine libretro port";
    homepage = "https://github.com/libretro/nxengine-libretro";
    license = lib.licenses.gpl3Only;
  };
}
