{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-08-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "8d268a6bb2cd799f8f2791ebb544a7ef550cfc6f";
    hash = "sha256-BWRDdFiWD4yO3YfNwhkV+tHcNXb6luaE5TD9jcJwvA0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
