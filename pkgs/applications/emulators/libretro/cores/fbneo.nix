{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "42160d563e3e40e818dbbb328ff1f65c4a03ad0e";
    hash = "sha256-dna6JsxYp5ilgPhSX3nDSznFlzET6jqZu5P9IH6PYvk=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
