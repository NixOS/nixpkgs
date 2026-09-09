{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fuse";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fuse-libretro";
    rev = "7d9826bdc1e4faf658293fa94a16cea81fd26bba";
    hash = "sha256-/NAkYUPQQGqEBwd3U+sge2EFpGsDvGMKMYQym1xLmRA=";
  };

  meta = {
    description = "Port of the Fuse Unix Spectrum Emulator to libretro";
    homepage = "https://github.com/libretro/fuse-libretro";
    license = lib.licenses.gpl3Only;
  };
}
