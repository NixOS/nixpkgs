{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "yabause";
<<<<<<< HEAD
  version = "0-unstable-2025-12-20";
=======
  version = "0-unstable-2024-10-21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "yabause";
<<<<<<< HEAD
    rev = "65af22e96beb6d9b0b9a50a81a39c86a6d604c1c";
    hash = "sha256-LafC48f1m6pRWhXmfN+D+5r9qCNm1v9uLJVq5Wa5naE=";
=======
    rev = "c35712c5ed33e18d77097f2059a036e19d1d66f2";
    hash = "sha256-4/gxWNPkGKBf4ti7ZF4GXgng6ZPyM9prrvK0S5tZ6V8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";
  # Disable SSE for non-x86. DYNAREC doesn't build on aarch64.
  makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "HAVE_SSE=0";
  preBuild = "cd yabause/src/libretro";

  meta = {
    description = "Port of Yabause to libretro";
    homepage = "https://github.com/libretro/yabause";
    license = lib.licenses.gpl2Only;
  };
}
