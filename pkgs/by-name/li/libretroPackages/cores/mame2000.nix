{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2000";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2000-libretro";
    rev = "181b42e5da0d2f0c7a2e59244f23633ed594de2e";
    hash = "sha256-ahyeOfany3ZiYKblb1e6QtLF+dRPeAPdZVgsudaZudo=";
  };

  makefile = "Makefile";
  makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "IS_X86=0";

  meta = {
    description = "Port of MAME ~2000 to libretro, compatible with MAME 0.37b5 sets";
    homepage = "https://github.com/libretro/mame2000-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
