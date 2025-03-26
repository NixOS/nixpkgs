{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-03-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "ad3b6536f57ec189defabc8aa0fe9d854d167d67";
    hash = "sha256-Nyzzr6XFQmtRVWxATIIONn3tnwwS6jLbbwHxoYXUDGU=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
