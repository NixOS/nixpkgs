{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-05-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "62697276b95848bd35b9c7b81daab899a98e0789";
    hash = "sha256-jisW5Mk5PF3rxj9mF5FJXtktAKEAq2a6DUvCXBgri3E=";
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
