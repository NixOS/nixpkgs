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
  version = "2.9.23";

  src = fetchurl {
    url = "mirror://sourceforge/panotools/libpano13-${finalAttrs.version}.tar.gz";
    hash = "sha256-58B203oUw5Q0liEV5H3b4YRSyj3lzkDiqu+nz1gV6ig=";
  };

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
