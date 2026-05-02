{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "5cd2221d04fef37ef2f99793acc100b445691612";
    hash = "sha256-uv7MKLlHzTWSeGd0SRCfF+4S+SiJeZny0OerU1MbWOI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
