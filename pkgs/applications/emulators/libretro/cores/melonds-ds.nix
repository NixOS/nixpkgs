{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
  libGLU,
  libGL,
  git,
}:
mkLibretroCore {
  core = "melonds-ds";
  version = "0-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonds-ds";
    rev = "bac0256dc6a8736c5a228f57c562257e45fd49f3";
    hash = "sha256-EeXYibPV9BPazC/i5UqXEd4BKlIZbNbPNgpsoo4ws7k=";
  };

  extraBuildInputs = [
    libGLU
    libGL
  ];

  extraNativeBuildInputs = [
    cmake
    git
  ];

  meta = {
    description = "Enhanced remake of the melonDS core for libretro";
    homepage = "https://github.com/JesseTG/melonds-ds";
    license = lib.licenses.gpl3Plus;
  };
}
