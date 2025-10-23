{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libjpeg,
  libpng,
  libtiff,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpano13";
  version = "2.9.22";

  src = fetchurl {
    url = "mirror://sourceforge/panotools/libpano13-${finalAttrs.version}.tar.gz";
    hash = "sha256-r/xoMM2+ccKNJzHcv43qKs2m2f/UYJxtvzugxoRAqOM=";
  };

  patches = [ ./cmake4.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    perl
  ];

  buildInputs = [
    libjpeg
    libpng
    libtiff
  ];

  meta = {
    description = "Free software suite for authoring and displaying virtual reality panoramas";
    homepage = "https://panotools.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.wegank ];
    platforms = lib.platforms.unix;
  };
})
