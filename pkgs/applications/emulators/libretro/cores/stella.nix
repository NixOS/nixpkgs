{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-05-16";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "03dbb069fd2d6fee0d58c5d96077bdf9c686a1e2";
    hash = "sha256-BiyicKZsoRXd/w0U2uvCjd0E3gzNvfNPbAt34nGdXdw=";
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
