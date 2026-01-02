{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pcsx-rearmed";
  version = "0-unstable-2025-12-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "pcsx_rearmed";
    rev = "a2640fe1a0e21729054cdb74db8a21e4bf6dde17";
    hash = "sha256-HzgpqgTcFT0Dz0SIn4zW4oF4FxOTYzgg1/sFi3XDwQ4=";
  };

  dontConfigure = true;

  meta = {
    description = "Port of PCSX ReARMed to libretro";
    homepage = "https://github.com/libretro/pcsx_rearmed";
    license = lib.licenses.gpl2Only;
  };
}
