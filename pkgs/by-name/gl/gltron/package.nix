{
  lib,
  stdenv,
  fetchurl,
  SDL,
  libGLU,
  libGL,
  zlib,
  libpng,
  libvorbis,
  libmikmod,
  SDL_sound,
}:

stdenv.mkDerivation rec {
  pname = "gltron";
  version = "0.70";
  src = fetchurl {
    url = "mirror://sourceforge/gltron/gltron-${version}-source.tar.gz";
    sha256 = "e0c8ebb41a18a1f8d7302a9c2cb466f5b1dd63e9a9966c769075e6b6bdad8bb0";
  };

  patches = [
    ./gentoo-prototypes.patch

    # gcc-14 build fix: https://sourceforge.net/p/gltron/patches/7/
    (fetchurl {
      name = "gcc-14.patch";
      url = "https://sourceforge.net/p/gltron/patches/7/attachment/gcc-14.patch";
      hash = "sha256-OJAUAM/OQVwxYnIacBkncNxMLn/HDCoysbi+Txe+DC8=";
    })
  ];

  postPatch = ''
    # Fix https://sourceforge.net/p/gltron/bugs/15
    sed -i /__USE_MISC/d lua/src/lib/liolib.c
  '';

  # The build fails, unless we disable the default -Wall -Werror
  configureFlags = [ "--disable-warn" ];

  buildInputs = [
    SDL
    libGLU
    libGL
    zlib
    libpng
    libvorbis
    libmikmod
    SDL_sound
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.gltron.org/";
    description = "Game based on the movie Tron";
    mainProgram = "gltron";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
