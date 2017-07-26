{ stdenv, fetchurl, cmake, libxml2, libxslt, boost, libarchive, python, antlr }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.9.5_beta";
  name = "srcml-${version}";

  src = fetchurl {
    url = "http://www.sdml.cs.kent.edu/lmcrs/srcML-${version}-src.tar.gz";
    sha256 = "13pswdi75qjsw7z75lz7l3yjsvb58drihla2mwj0f9wfahaj3pam";
  };

  prePatch = ''
    patchShebangs .
    substituteInPlace CMake/install.cmake --replace /usr/local $out
    '';

  nativeBuildInputs = [ cmake antlr ];
  buildInputs = [ libxml2 libxslt boost libarchive python ];

  meta = {
    description = "Infrastructure for exploration, analysis, and manipulation of source code";
    homepage = "http://www.srcml.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leenaars ];
  };
}
