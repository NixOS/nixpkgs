{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "7d9148f97c9f4ba8903ba3e19cbfb418c779bbb5";
    hash = "sha256-l1PdtMtYmnYzUyEoAuZ2Wh9g85kUFHTfq6iBJOZ5Cfc=";
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
