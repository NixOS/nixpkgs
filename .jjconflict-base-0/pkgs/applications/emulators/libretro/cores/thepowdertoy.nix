{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "thepowdertoy";
  version = "0-unstable-2024-10-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ThePowderToy";
    rev = "5d9c749780063b87bd62ddb025dee4241f196f26";
    hash = "sha256-BYeQ2WZgyvjDH5+akrVP5TlLq6Go3NKXB7zeR9oaaJ8=";
  };

  extraNativeBuildInputs = [ cmake ];
  makefile = "Makefile";
  postBuild = "cd src";

  meta = {
    description = "Port of The Powder Toy to libretro";
    homepage = "https://github.com/libretro/ThePowderToy";
    license = lib.licenses.gpl3Only;
  };
}
