{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
}:
mkLibretroCore {
  core = "blastem";
  version = "0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "blastem";
    rev = "ec73825ece2a134beb7825a5fd6fd21a398ff12e";
    hash = "sha256-/tKLDecaH7uXybLRHFThmOKG/XL4oTqDGVQl3DiWAKs=";
  };

  # cpu_dsl.py generates the CPU cores at build time
  extraNativeBuildInputs = [ python3 ];

  meta = {
    description = "Port of BlastEm to libretro";
    homepage = "https://github.com/libretro/blastem";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.x86;
  };
}
