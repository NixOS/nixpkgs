{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "92313128c3e2afdb9b3decf6642d342af18a1ab5";
    hash = "sha256-b1GaRB9Iv3qqyb3I9XKmEbkiplV+Wi3TflJdnQboLbw=";
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
