{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-01-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "274cdf95a16981c130015a8b4808a95ef5b46203";
    hash = "sha256-BS+Siam2jz6mFDz0mtvWH3+Is3Il78UbWkCh2f+DSAE=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
