{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "9bbd209f4a9505b1cd58242fa4b6790da020adcb";
    hash = "sha256-MbQ9JAPsqBRTmCkTUQmC9mwNk8XUH7evJ1hSr7+/qx8=";
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
