{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "yabause";
  version = "0-unstable-2026-05-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "yabause";
    rev = "8926b0c6c347f8c5c755911ddb0ac695420ffbf8";
    hash = "sha256-6MTUq1p3PWNwPqFmLu21BVOrHBl1koEQ98d9+B8qYq8=";
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
