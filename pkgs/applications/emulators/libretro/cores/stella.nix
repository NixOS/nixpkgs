{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "65631824500f8764ee3da726f5f24cb06d243b60";
    hash = "sha256-Qrr19OF6YGfvOAIBS0Irhfl4VYVFfA20ZNGIJoKboNE=";
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
