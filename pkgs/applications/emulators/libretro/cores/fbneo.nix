{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-08-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "525a07bd5abd52481a653dc790b987b8f50d0686";
    hash = "sha256-O1QEvQ2ZZ7rU6KObV1hFaYLVWwDZ6Lu30JMbln7Z7DA=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
