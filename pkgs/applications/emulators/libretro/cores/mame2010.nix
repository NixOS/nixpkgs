{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2010";
  version = "0-unstable-2026-06-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2010-libretro";
    rev = "36c36bb0a59902aa75af3e80853f7f893d7ffe91";
    hash = "sha256-tudxNTySzhoN4SzlzqhzuDE9Qmyr9Ud87fCiW+0MITc=";
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
