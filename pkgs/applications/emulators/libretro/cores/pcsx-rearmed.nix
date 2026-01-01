{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pcsx-rearmed";
<<<<<<< HEAD
  version = "0-unstable-2025-12-28";
=======
  version = "0-unstable-2025-11-24";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "pcsx_rearmed";
<<<<<<< HEAD
    rev = "a2640fe1a0e21729054cdb74db8a21e4bf6dde17";
    hash = "sha256-HzgpqgTcFT0Dz0SIn4zW4oF4FxOTYzgg1/sFi3XDwQ4=";
=======
    rev = "9059485691c44cb3a555464b06eddfb1082d586c";
    hash = "sha256-sm59Xo6bEiajbmRYbCNnWToDLpJPdaJhovJe+g+GWVg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontConfigure = true;

  meta = {
    description = "Port of PCSX ReARMed to libretro";
    homepage = "https://github.com/libretro/pcsx_rearmed";
    license = lib.licenses.gpl2Only;
  };
}
