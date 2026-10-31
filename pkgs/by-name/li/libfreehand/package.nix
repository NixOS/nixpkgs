{
  lib,
  stdenv,
  fetchzip,
  perl,
  pkg-config,
  boost,
  cppunit,
  doxygen,
  gperf,
  icu,
  lcms2,
  librevenge,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libfreehand";
  version = "0.1.4";

  src = fetchzip {
    url = "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-${finalAttrs.version}.tar.xz";
    hash = "sha256-zIH6zx0TI+tP9odEuW5ZP42jzfXWcGCIj5XbsSibLN8=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    boost
    cppunit
    doxygen
    gperf
    icu
    lcms2
    librevenge
    zlib
  ];

  configureFlags = [ "--disable-werror" ];

  meta = {
    description = "Adobe Freehand import library";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
