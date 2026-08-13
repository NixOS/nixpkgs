{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dosbox-libretro";
    rev = "4024bf0048c261db58ef98cb5e16de291c429f4e";
    hash = "sha256-sHq4xObXvgpaEnqtjJikN8g/io6FQdZWztifzSGPdH4=";
  };

  env.CXXFLAGS = "-std=gnu++11";

  meta = {
    description = "Port of DOSBox to libretro";
    homepage = "https://github.com/libretro/dosbox-libretro";
    license = lib.licenses.gpl2Only;
  };
}
