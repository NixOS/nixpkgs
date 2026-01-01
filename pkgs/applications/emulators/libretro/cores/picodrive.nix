{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
<<<<<<< HEAD
  version = "0-unstable-2025-12-03";
=======
  version = "0-unstable-2025-11-17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
<<<<<<< HEAD
    rev = "3365b1774bc8680be9899968fe45b224ad2f11c1";
    hash = "sha256-hn80Dkdf6dMmCFoh9QeySVbF7tu8Vc1NfAl3SV8AZLg=";
=======
    rev = "046e5ff91eb4bfa728e51e01304ff73cf6b4ee96";
    hash = "sha256-uoUqap7hMg8C2Ouud0UTtkWeZbtga9GVqSipHZK90/s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
