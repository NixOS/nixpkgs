{
  lib,
  SDL,
  SDL_image,
  expat,
  fetchpatch,
  fetchurl,
  libGL,
  libvorbis,
  lua,
  pkg-config,
  scons,
  smpeg,
  stdenv,
  zip,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btanks";
  version = "0.9.8083";

  src = fetchurl {
    url = "mirror://sourceforge/btanks/btanks-${finalAttrs.version}.tar.bz2";
    hash = "sha256-P9LOaitF96YMOxFPqa/xPLPdn7tqZc3JeYt2xPosQ0E=";
  };

  patches = [
    (fetchpatch {
      name = "lua52.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/lua52.patch?h=btanks&id=cd0e016963238f16209baa2da658aa3fad36e33d";
      hash = "sha256-Xwl//sfGprhg71jf+X3q8qxdB+5ZtqJrjBxS8+cw5UY=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/-/raw/debian/0.9.8083-9/debian/patches/gcc-4.7.patch";
      hash = "sha256-JN7D+q63EvKJX9wAEQgcVqE1VZzMa4Y1CPIlA3uYtLc=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/-/raw/debian/0.9.8083-9/debian/patches/pow10f.patch";
      hash = "sha256-6QFP1GTwqXnjfekzEiIpWKCD6HOcGusYW+02sUE6hcA=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/-/raw/debian/0.9.8083-9/debian/patches/python3.patch";
      hash = "sha256-JpK409Myi8mxQaunmLFKKh1NKvKLXpNHHsDvRee8OoQ=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/-/raw/debian/0.9.8083-9/debian/patches/scons.patch";
      hash = "sha256-JCvBY2fOV8Sc/mpvEsJQv1wKcS1dHqYxvRk6I9p7ZKc=";
    })
  ];

  nativeBuildInputs = [
    SDL
    pkg-config
    scons
    smpeg
    zip
  ];

  buildInputs = [
    SDL
    SDL_image
    expat
    libGL
    libvorbis
    lua
    smpeg
    zlib
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL_image}/include/SDL";

  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    homepage = "https://sourceforge.net/projects/btanks/";
    description = "Fast 2d tank arcade game with multiplayer and split-screen modes";
    license = lib.licenses.gpl2Plus;
    mainProgram = "btanks";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (SDL.meta) platforms;
  };
})
