{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-06-09";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "3e3061809913e59a4378737127ce0ae95b36e889";
    hash = "sha256-fKivb4sFR4F0ub1NLpazLg3i3M9LOely08M8kBEczmo=";
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
