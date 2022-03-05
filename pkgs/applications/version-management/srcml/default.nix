{ lib, stdenv, fetchurl, cmake, libxml2, libxslt, boost, libarchive, python2, antlr2,
  curl
}:

with lib;

stdenv.mkDerivation rec {
  version = "0.9.5_beta";
  pname = "srcml";

  src = fetchurl {
    url = "http://www.sdml.cs.kent.edu/lmcrs/srcML-${version}-src.tar.gz";
    sha256 = "13pswdi75qjsw7z75lz7l3yjsvb58drihla2mwj0f9wfahaj3pam";
  };

  prePatch = ''
    patchShebangs .
    substituteInPlace CMake/install.cmake --replace /usr/local $out
    '';

  patches = [
    ./gcc6.patch
  ];

  nativeBuildInputs = [ cmake antlr2 ];
  buildInputs = [ libxml2 libxslt boost libarchive python2 curl ];

  meta = {
    description = "Infrastructure for exploration, analysis, and manipulation of source code";
    homepage = "https://www.srcml.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leenaars ];
  };
}
