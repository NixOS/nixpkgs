{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "hatari";
  version = "0-unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "hatari";
    rev = "c605d3aa342f2ad8f915f94bf03bae018e1be7b7";
    hash = "sha256-UJyfIt5+anXaqqMmL9JNTBvXu5bmyMYloYc8fWxx2m0=";
  };

  extraNativeBuildInputs = [ which ];
  dontConfigure = true;
  # zlib is already included in mkLibretroCore as buildInputs
  makeFlags = [ "EXTERNAL_ZLIB=1" ];

  meta = {
    description = "Port of Hatari to libretro";
    homepage = "https://github.com/libretro/hatari";
    license = lib.licenses.gpl2Only;
  };
}
