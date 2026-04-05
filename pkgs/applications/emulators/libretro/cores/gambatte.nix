{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "9669d1f9266684e60ac1c5ed9b438bd2a02a3b4d";
    hash = "sha256-/mxkjVG7fkjUZ1LHNtFYA0/7ZTyvAYtcF5xO8cxWkzc=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
