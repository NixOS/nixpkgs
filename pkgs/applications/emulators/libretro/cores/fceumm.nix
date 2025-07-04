{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2025-05-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "3544ff567ecc417c170641587083b976739ef9db";
    hash = "sha256-eNmzWLJVPeqFFEcFIhOQCn9OMrBp0iraTcft5pJVvvE=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
