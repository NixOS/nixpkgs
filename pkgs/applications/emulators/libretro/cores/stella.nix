{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
<<<<<<< HEAD
  version = "0-unstable-2025-12-28";
=======
  version = "0-unstable-2025-11-26";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
<<<<<<< HEAD
    rev = "7f62c3e1390f629cbd56cbb5172f7e2143b30440";
    hash = "sha256-IMrqBu7beSuJNfl2pyzRm5yExXaMkl+si0YVDeRbAcU=";
=======
    rev = "ec7ad887c777a7924fdc786a9c5901e65d4c6cd0";
    hash = "sha256-M0DD+xNS+kf9x49YPZHulmYeV36fTh09rsRtQT+/zFY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
