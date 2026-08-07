{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2010";
  version = "0-unstable-2026-07-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2010-libretro";
    rev = "484456818393505dd4367e6e4c116c573c04a1ec";
    hash = "sha256-CstMUeTxOsL419R2kzSK6hDd1okxsbtwMvqjwzSf3bI=";
  };

  makefile = "Makefile";
  makeFlags = lib.optionals stdenv.hostPlatform.isAarch64 [
    "PTR64=1"
    "ARM_ENABLED=1"
    "X86_SH2DRC=0"
    "FORCE_DRC_C_BACKEND=1"
  ];

  meta = {
    description = "Port of MAME ~2010 to libretro, compatible with MAME 0.139 sets";
    homepage = "https://github.com/libretro/mame2010-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
