{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2000";
  version = "0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2000-libretro";
    rev = "131ae96d72a613451517fa2eca0b598b2b266a94";
    hash = "sha256-fbOGMebiqckcwPk81YrdSHwti6qrLSxB3qYSY8SEqRs=";
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
