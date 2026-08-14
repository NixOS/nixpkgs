{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "meteor";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "meteor-libretro";
    rev = "94226aded4afbcd3bd1bad69277db7a2fae64a4a";
    hash = "sha256-OpAq3Yjzm3qtj+P71Kx36980PTx01lloNEq0CXbJeIc=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of Meteor to libretro";
    homepage = "https://github.com/libretro/meteor";
    license = lib.licenses.gpl3Only;
  };
}
