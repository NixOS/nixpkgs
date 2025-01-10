{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-01-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "b8780c057029db8768c9a057b0bc28f9a12609d8";
    hash = "sha256-cK3ILA0Ape6rHf5dPbXOMmQ69ZPZ/qrxeKYA1LniBEk=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
