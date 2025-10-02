{
  lib,
  fetchFromGitHub,
  libGL,
  libGLU,
  which,
  zip,
  mkLibretroCore,
}:
let
  # https://github.com/libretro/scummvm/blob/master/backends/platform/libretro/dependencies.mk#L8-L14
  libretro-common-src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-common";
    rev = "70ed90c42ddea828f53dd1b984c6443ddb39dbd6";
    hash = "sha256-ItsUNbJCK/m/3VprK/zHD2UF5MhPC8b7jM3qS/oHU2A=";
  };

  libretro-deps-src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-deps";
    rev = "abf5246b016569759e7d1b0ea91bb98c2e34d160";
    hash = "sha256-tdGytbSNMCfMuXIAUunOSVw9qFq2rRaruELhZwEmhWE=";
  };
in
mkLibretroCore {
  core = "scummvm";
  version = "0-unstable-2025-07-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "scummvm";
    rev = "686cdd13719b92554fa46b264c512ca7deec7a96";
    hash = "sha256-3w1rYVPX7ENGUgKdrFRQShWoEXfagxdtzd98m1hKeYU=";
  };

  extraBuildInputs = [
    libGL
    libGLU
    zip
  ];

  extraNativeBuildInputs = [ which ];

  preConfigure = "cd backends/platform/libretro";

  preBuild = ''
    mkdir -p deps/libretro-{common,deps}
    cp -a ${libretro-common-src}/* deps/libretro-common
    cp -a ${libretro-deps-src}/* deps/libretro-deps
    chmod -R u+w deps/

    patchShebangs ./scripts/*
  '';

  makefile = "Makefile";

  meta = {
    description = "Libretro port of ScummVM";
    homepage = "https://github.com/libretro/scummvm";
    license = lib.licenses.gpl2Only;
  };
}
