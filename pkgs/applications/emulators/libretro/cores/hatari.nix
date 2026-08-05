{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "hatari";
  version = "0-unstable-2026-07-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "hatari";
    rev = "97faf4271c67a5336fba6bb7960c77bdc5d29f9e";
    hash = "sha256-Jkq7FKpf+zMaRk6XG31Sco3iXklPvVh/MDm5p52JMRo=";
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
