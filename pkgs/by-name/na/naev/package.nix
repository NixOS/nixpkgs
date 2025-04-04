{
  lib,
  SDL2,
  SDL2_image,
  enet,
  fetchFromGitHub,
  freetype,
  glpk,
  intltool,
  libpng,
  libunibreak,
  libvorbis,
  libwebp,
  libxml2,
  luajit,
  meson,
  ninja,
  openal,
  openblas,
  pcre2,
  physfs,
  pkg-config,
  python3,
  stdenv,
  suitesparse,
}:

stdenv.mkDerivation rec {
  pname = "naev";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "naev";
    repo = "naev";
    rev = "v${version}";
    hash = "sha256-vdPkACgLGSTb9E/HZR5KoXn/fro0iHV7hX9kJim1j/M=";
    fetchSubmodules = true;
  };

  buildInputs = [
    SDL2
    SDL2_image
    enet
    freetype
    glpk
    libpng
    libunibreak
    libvorbis
    libwebp
    libxml2
    luajit
    openal
    openblas
    pcre2
    physfs
    suitesparse
  ];

  nativeBuildInputs = [
    (python3.withPackages (
      ps: with ps; [
        pyyaml
        mutagen
      ]
    ))
    meson
    ninja
    pkg-config
    intltool
  ];

  mesonFlags = [
    "-Ddocs_c=disabled"
    "-Ddocs_lua=disabled"
    "-Dluajit=enabled"
  ];

  postPatch = ''
    patchShebangs --build dat/outfits/bioship/generate.py utils/build/*.py utils/*.py

    # Add a missing include to fix the build against luajit-2.1.1741730670.
    # Otherwise the build fails as:
    #   src/lutf8lib.c:421:22: error: 'INT_MAX' undeclared (first use in this function)
    # TODO: drop after 0.12.3 release
    sed -i '1i#include <limits.h>' src/lutf8lib.c
  '';

  meta = {
    description = "2D action/rpg space game";
    mainProgram = "naev";
    homepage = "http://www.naev.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ralismark ];
    platforms = lib.platforms.linux;
  };
}
