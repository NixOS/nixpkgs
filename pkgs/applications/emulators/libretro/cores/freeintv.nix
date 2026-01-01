{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
<<<<<<< HEAD
  version = "0-unstable-2025-12-26";
=======
  version = "0-unstable-2025-11-11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
<<<<<<< HEAD
    rev = "df5a5312985b66b1ec71b496868641e40b7ad1c9";
    hash = "sha256-xpcDAvxHvnuiQiWBYSwPKGE+Zg1lcs/6L4hMhpb1G1g=";
=======
    rev = "1b51f41238ef9691d9fe16722f7d093bb6a6e379";
    hash = "sha256-kuznjK9HnqR42Cuz6bmUhEUnerrWb5VIvkiU0p//ecw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
