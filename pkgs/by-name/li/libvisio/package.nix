{
  lib,
  stdenv,
  fetchurl,
  boost,
  libwpd,
  libwpg,
  pkg-config,
  zlib,
  gperf,
  librevenge,
  libxml2,
  icu,
  perl,
  cppunit,
  doxygen,
}:

stdenv.mkDerivation rec {
  pname = "libvisio";
  version = "0.1.9";

  outputs = [
    "out"
    "bin"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libvisio/${pname}-${version}.tar.xz";
    hash = "sha256-SmHQhtqj9cnbij/Rttv8Kbp1YFeqazzCOHj9SFQ2Kvk=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    doxygen
    perl
    gperf
  ];
  buildInputs = [
    boost
    libwpd
    libwpg
    zlib
    librevenge
    libxml2
    icu
    cppunit
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library providing ability to interpret and import visio diagrams into various applications";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libvisio";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nickcao ];
  };
}
