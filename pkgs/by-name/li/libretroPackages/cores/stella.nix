{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-09-25";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "36db8267e443a1ddfe4fabc0a3d42ec2b2332cb4";
    hash = "sha256-g3x/ViAbvYMOmkLX1yVM8McfssBZZUou0KIl0dmzHX0=";
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
