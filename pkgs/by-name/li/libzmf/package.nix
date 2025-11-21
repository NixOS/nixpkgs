{
  lib,
  stdenv,
  fetchurl,
  boost,
  icu,
  libpng,
  librevenge,
  zlib,
  doxygen,
  pkg-config,
  cppunit,
}:

stdenv.mkDerivation rec {
  pname = "libzmf";
  version = "0.0.2";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/libzmf/${pname}-${version}.tar.xz";
    sha256 = "08mg5kmkjrmqrd8j5rkzw9vdqlvibhb1ynp6bmfxnzq5rcq1l197";
  };

  patches = [
    # https://git.libreoffice.org/libzmf/+/48f94abff2fcc4943626a62c6180c60862288b08%5E%21
    ./doxygen.patch
  ];

  buildInputs = [
    boost
    icu
    libpng
    librevenge
    zlib
    cppunit
  ];
  nativeBuildInputs = [
    doxygen
    pkg-config
  ];
  configureFlags = [ "--disable-werror" ];

  meta = {
    description = "Library that parses the file format of Zoner Callisto/Draw documents";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libzmf";
    downloadPage = "http://dev-www.libreoffice.org/src/libzmf/";
  };
}
