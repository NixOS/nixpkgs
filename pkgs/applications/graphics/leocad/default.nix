/*
To use aditional parts libraries
set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

{ stdenv, fetchsvn, qt4, zlib }:

stdenv.mkDerivation rec {
  name = "leocad-${version}";
  version = "0.81";

  src = fetchsvn {
    url = "http://svn.leocad.org/tags/${name}";
    sha256 = "1190gb437ls51hhfiwa79fq131026kywpy3j3k4fkdgfr8a9v3q8";
  };

  buildInputs = [ qt4 zlib ];

  prefixKey = "INSTALL_PREFIX=";
  configureScript = "qmake leocad.pro";
  postPatch = ''
    substituteInPlace common/camera.cpp --replace "isnan(" "std::isnan("
  '';

  meta = with stdenv.lib; {
    description = "CAD program for creating virtual LEGO models";
    homepage = http://www.leocad.org/;
    license = licenses.gpl2;
    inherit (qt4.meta) platforms;
  };
}
