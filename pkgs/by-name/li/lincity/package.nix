{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gettext,
  libX11,
  libXext,
  xorgproto,
  libICE,
  libSM,
  libpng12,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lincity";
  version = "1.13.1";

  src = fetchurl {
    url = "mirror://sourceforge/lincity/lincity-${finalAttrs.version}.tar.gz";
    hash = "sha256-e0y9Ef/Uy+15oKrbJfKxw04lqCARgvuyWc4vRQ/lAV0=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ gettext ];

  buildInputs = [
    libICE
    libpng12
    libSM
    libX11
    libXext
    xorgproto
    zlib
  ];

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/l/lincity/1.13.1-13/debian/patches/extern-inline-functions-777982";
      hash = "sha256-4LKZuUztvfOUhkKwjZJnku1yfBVSqT5Uybx8MPkftxk=";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/l/lincity/1.13.1-13/debian/patches/clang-ftbfs-757859";
      hash = "sha256-91mzptO37x1UfY6pa6CrEkSkfhu1KNJDqIB5zbi3GSU=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/l/lincity/1.13.1-16/debian/patches/fix-implicit-declarations-823432";
      hash = "sha256-S9TQ7KcmGGsQeTKLXqF/9FDXv/+WjrEPL4ly7DSki1s=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/l/lincity/1.13.1-16/debian/patches/fix-implicit-function-declarations-1066295";
      hash = "sha256-KlmXBWPI8lFWO8kPA78uG52DCs8NeGmNNFpZYfCwo5M=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/l/lincity/1.13.1-16/debian/patches/delay_timers";
      hash = "sha256-IxstC74R7kige0ormFLGEj4uzbJt/b8bLmygheN08II=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/l/lincity/1.13.1-16/debian/patches/map-max-draw";
      hash = "sha256-9qLPrmEKMMrSVwqtEvoiyjPPo1eLO3u6bCJslubmBJU=";
    })
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: modules/.libs/libmodules.a(rocket_pad.o):/build/lincity-1.13.1/modules/../screen.h:23:
  #     multiple definition of `monthgraph_style'; ldsvguts.o:/build/lincity-1.13.1/screen.h:23: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postPatch = ''
    sed -e 's@\[MPS_INFO_CHARS\]@[MPS_INFO_CHARS+8]@' -i mps.c -i mps.h

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      sed -i '/\#include \"malloc.h\"/d' readpng.c
    ''}
  '';

  meta = {
    description = "City simulation game";
    mainProgram = "xlincity";
    license = lib.licenses.gpl2Plus;
    homepage = "https://sourceforge.net/projects/lincity";
    maintainers = with lib.maintainers; [ iedame ];
  };
})
