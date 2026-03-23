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

stdenv.mkDerivation (finalAttrs: {
  pname = "log4cxx";
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://apache/logging/log4cxx/${finalAttrs.version}/apache-log4cxx-${finalAttrs.version}.tar.gz";
    hash = "sha256-GHyFg29bLyf7Ho13x/Hyk5cl8fZJi3QrDdVpujCWX9I=";
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
})
