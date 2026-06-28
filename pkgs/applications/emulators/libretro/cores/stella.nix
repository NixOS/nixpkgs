{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "65fc7d66abfc8dfba5033d88523437b83664ea2b";
    hash = "sha256-hYYZyHtWjo3BgX73Vxj8JG/2vQ7JtqT+4jPWLN+zZHw=";
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
