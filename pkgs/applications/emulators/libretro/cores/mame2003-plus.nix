{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003-plus";
<<<<<<< HEAD
  version = "0-unstable-2025-12-30";
=======
  version = "0-unstable-2025-11-13";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-plus-libretro";
<<<<<<< HEAD
    rev = "f6c6d9d3e436e355430f70cd4c85349259abcddb";
    hash = "sha256-skAK95mdoQc4mr5E4KXmQdhr1NMppch20Aa1yZuJGis=";
=======
    rev = "62c7089644966f6ac5fc79fe03592603579a409d";
    hash = "sha256-NHJfZpo4/aR9a6Sn3x+BQaVfKtkMBUoDQlgtvIkXDFI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003+ to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-plus-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
