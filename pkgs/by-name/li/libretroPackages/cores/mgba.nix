{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  cmake,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2026-09-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "7a12d6d4b9acb14c0ae62c9166b6a2f3d08007f6";
    hash = "sha256-wjoiZnAIG1L6Sox8HLCPLwrAm2c3XJNNoPn3aftUEBw=";
  };

  extraNativeBuildInputs = [ cmake ];
  cmakeFlags = [
    (lib.cmakeBool "LIBMGBA_ONLY" true)
    (lib.cmakeBool "BUILD_LIBRETRO" true)
  ];
  makefile = "Makefile";

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
