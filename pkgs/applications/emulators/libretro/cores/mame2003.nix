{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003";
<<<<<<< HEAD
  version = "0-unstable-2025-12-13";
=======
  version = "0-unstable-2025-10-21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-libretro";
<<<<<<< HEAD
    rev = "6c32fa9fc005d7e924909c6ff4684da9abb00ceb";
    hash = "sha256-NPPwLruxafBUwKYy+DuLrTZa5QlbneWQSvCRN6ispdM=";
=======
    rev = "3570605767a447c13b087a5946189bcbafe11e1d";
    hash = "sha256-BcPiNYEi6uE8aSpPDNgZ8vmzSnZJUparEM3CEdexbPo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Fix build with GCC 14
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003 to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
