{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libglvnd,
  libtool,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  xorg,
}:

stdenv.mkDerivation {
  pname = "pinball";
  version = "0.3.20201218-unstable-2024-11-14";

  src = fetchFromGitHub {
    owner = "adoptware";
    repo = "pinball";
    rev = "7f6887d8912340c0eee7f96b4c4bb84c8d889246";
    hash = "sha256-8wuux7eC0OkgL/m20eyRGRrAF1lBGAbd7Gmid9cNPto=";
  };

  postPatch = ''
    sed -i 's/^AUTOMAKE_OPTIONS = gnu$/AUTOMAKE_OPTIONS = foreign/' Makefile.am
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libglvnd
    libtool
    SDL2
    SDL2_image
    SDL2_mixer
    xorg.libSM
  ];
  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL2_image}/include/SDL2"
    "-I${lib.getDev SDL2_mixer}/include/SDL2"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/adoptware/pinball";
    description = "Emilia Pinball simulator";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
