{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
}:
mkLibretroCore {
  core = "blastem";
  version = "0-unstable-2026-11-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "blastem";
    rev = "aa11275a99b3ea0ee477fed2844bb7d9f9faf3f6";
    hash = "sha256-nSBX8e8ZHx1pGybc6ZKrlDGRZAQOaQHlcJnJ+jZ2OGg=";
  };

  # cpu_dsl.py generates the CPU cores at build time
  extraNativeBuildInputs = [ python3 ];

  meta = {
    description = "Port of BlastEm to libretro";
    homepage = "https://github.com/libretro/blastem";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
