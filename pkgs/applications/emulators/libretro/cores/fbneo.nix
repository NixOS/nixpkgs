{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-06-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "845a1fd30f895ab69669f03c97eb5cfbf0f8d97a";
    hash = "sha256-fy6LSeOlIQkrLGnMQhXSR4EwC+4crAirQKnWt+7S1cI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
