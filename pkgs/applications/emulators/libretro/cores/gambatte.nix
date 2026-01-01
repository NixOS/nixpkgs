{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
<<<<<<< HEAD
  version = "0-unstable-2025-12-19";
=======
  version = "0-unstable-2025-11-14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
<<<<<<< HEAD
    rev = "308255e4a3acb38a054ebb42a5e2fe5c50eebd66";
    hash = "sha256-a75F7kfrVfIVt5yvYIu+oVmpXlOdTDTs5IX1Q5NB8WU=";
=======
    rev = "6924c76ba03dadddc6e97fa3660f3d3bc08faa94";
    hash = "sha256-VhHPr+zM7YfwdxdhGQ8zkA/9r1ZYr4sgIr147DzKCJw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
