{ lib, stdenv, fetchurl, libtool, cmake, libxml2, cppunit, boost
, apr, aprutil, db, expat
}:

stdenv.mkDerivation rec {
  pname = "log4cxx";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://apache/logging/log4cxx/${version}/apache-${pname}-${version}.tar.gz";
    hash = "sha256-CfR0iqVnXvXAdwvtv14ASIZokzxak1pDrFuFviQ2xIo=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "\\\''${prefix}/" ""
  '';

  buildInputs = [ libxml2 cppunit boost apr aprutil db expat ];
  nativeBuildInputs = [ libtool cmake ];

  meta = {
    homepage = "https://logging.apache.org/log4cxx/index.html";
    description = "Logging framework for C++ patterned after Apache log4j";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
