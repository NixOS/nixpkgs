{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-08-28";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "749a21f653cf85fcedf4fe514ac8df1ad308be8e";
    hash = "sha256-N5E+Ci6cTvG9/Yqg5NdPZB00ThNKc6SS7qCWlmCYd6I=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
