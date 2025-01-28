{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2025-01-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "10af0c78ba0e3516e70f4ed7c6020827bdb2647e";
    hash = "sha256-xxyWvsDF3FXTaP7GOGr9Zym0DgNZKJ4x9BDUgDzcHYA=";
  };

  extraNativeBuildInputs = [ cmake ];
  makefile = "Makefile";
  cmakeFlags = [
    "-DBUILD_LIBRETRO_CORE=ON"
  ];

  meta = {
    description = "Port of SwanStation (a fork of DuckStation) to libretro";
    homepage = "https://github.com/libretro/swanstation";
    license = lib.licenses.gpl3Only;
  };
}
