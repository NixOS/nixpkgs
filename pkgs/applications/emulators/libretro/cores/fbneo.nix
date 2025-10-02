{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-09-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "2d05f6cd665d6a2f0a876e2f50192c3fce53ed65";
    hash = "sha256-FQI8LPNYQDB1Jo04EGJGbgTncmwfzuTXj1GK9QsT8uQ=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
