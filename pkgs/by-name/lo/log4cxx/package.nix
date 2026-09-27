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
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://apache/logging/log4cxx/${finalAttrs.version}/apache-log4cxx-${finalAttrs.version}.tar.gz";
    hash = "sha256-ai5A36a4GpqBTvIIPRgbJU+IMk7/9ng2jl5hGIpY/T0=";
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
