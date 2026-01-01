{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "genesis-plus-gx";
<<<<<<< HEAD
  version = "0-unstable-2025-12-21";
=======
  version = "0-unstable-2025-11-21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "Genesis-Plus-GX";
<<<<<<< HEAD
    rev = "7c5819b7bd0b84c3265ee7dfcd7b90210ed7d687";
    hash = "sha256-3YrRWxKk6Uci5MKS5lQYU+edrLdsFYIAR6pTPXwiy8c=";
=======
    rev = "e48a37173350b5aec2a6431add7c1a625d1f28bf";
    hash = "sha256-xxqSx199DI7nQ+3xq4CP8uhtmQ2UGxNG39kYvGPXdag=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Enhanced Genesis Plus libretro port";
    homepage = "https://github.com/libretro/Genesis-Plus-GX";
    license = lib.licenses.unfreeRedistributable;
  };
}
