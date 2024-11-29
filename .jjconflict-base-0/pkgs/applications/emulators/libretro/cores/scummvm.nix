{
  lib,
  fetchFromGitHub,
  fluidsynth,
  libGL,
  libGLU,
  libjpeg,
  libvorbis,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "scummvm";
  version = "0-unstable-2022-04-06";

  # This is the old source code before they upstreamed the source code,
  # so now the libretro related code lives in the scummvm/scummvm repository.
  # However this broke the old way we were doing builds, so for now point
  # to a mirror with the old source code until this issue is fixed.
  # TODO: switch to libretro/scummvm since this is more up-to-date
  src = fetchFromGitHub {
    owner = "libretro-mirrors";
    repo = "scummvm";
    rev = "2fb2e4c551c9c1510c56f6e890ee0300b7b3fca3";
    hash = "sha256-wrlFqu+ONbYH4xMFDByOgySobGrkhVc7kYWI4JzA4ew=";
  };

  extraBuildInputs = [
    fluidsynth
    libjpeg
    libvorbis
    libGLU
    libGL
  ];
  makefile = "Makefile";
  preConfigure = "cd backends/platform/libretro/build";

  meta = {
    description = "Libretro port of ScummVM";
    homepage = "https://github.com/libretro-mirrors/scummvm";
    license = lib.licenses.gpl2Only;
  };
}
