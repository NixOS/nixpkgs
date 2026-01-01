{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
<<<<<<< HEAD
  version = "0-unstable-2025-12-26";
=======
  version = "0-unstable-2024-10-16";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
<<<<<<< HEAD
    rev = "345f12b7d45d7013602a4a3b72287f529bd78042";
    hash = "sha256-2FkBsiKOzf/sMtKA1vI0ixWP9/ghs/N7zA7/m6h6gZ0=";
=======
    rev = "67a29e60a4d194b675c9272b21b61eaa022f3ba3";
    hash = "sha256-8896EWNbzVyr3MS1jtWD3pLur7ZvAhhJmrwkW3ayzkU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
