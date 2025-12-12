{
  lib,
  stdenv,
  fetchurl,
  libtool,
  cmake,
  libxml2,
  cppunit,
  boost,
  apr,
  aprutil,
  db,
  expat,
}:

stdenv.mkDerivation rec {
  pname = "log4cxx";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://apache/logging/log4cxx/${version}/apache-${pname}-${version}.tar.gz";
    hash = "sha256-qiP0fDFkqiz4SMIli0tLw3Lnlk1KPtR8K0pKkVxd+jc=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "\\\''${prefix}/" ""
  '';

  buildInputs = [
    libxml2
    cppunit
    boost
    apr
    aprutil
    db
    expat
  ];
  nativeBuildInputs = [
    libtool
    cmake
  ];

  meta = {
    homepage = "https://logging.apache.org/log4cxx/index.html";
    description = "Logging framework for C++ patterned after Apache log4j";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
