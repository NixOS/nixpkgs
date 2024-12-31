{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2024-12-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "66ced08c693094f2eaefed5e11bd596c41028959";
    hash = "sha256-gXk9T62wns7QixY98RSjfM/OW6SfH8N3NcjZ328WSAM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
