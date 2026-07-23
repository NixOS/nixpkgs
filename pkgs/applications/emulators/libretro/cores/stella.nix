{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-05-24";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "a720cccc55ae9bce007e748b53371914951f9f32";
    hash = "sha256-TAR1/FiVMz6YYzbLB8maZcsU+0h6lo8lpY31Y+gGj1k=";
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
