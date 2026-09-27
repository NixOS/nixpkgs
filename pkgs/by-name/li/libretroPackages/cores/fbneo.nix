{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-09-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "aceeebed9e7edc8a28652365a064baee9a16e274";
    hash = "sha256-uZiCA11S6HCXn9BevbtCEpNxqNUvqDOk2UL4XVhAIsw=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
