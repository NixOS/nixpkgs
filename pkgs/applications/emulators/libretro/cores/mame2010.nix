{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2010";
  version = "0-unstable-2024-10-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2010-libretro";
    rev = "c5b413b71e0a290c57fc351562cd47ba75bac105";
    hash = "sha256-p+uEhxjr/07YJxInhW7oJDr8KurD36JxnSfJo17FOxM=";
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
