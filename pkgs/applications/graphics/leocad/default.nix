/*
To use aditional parts libraries
set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

{ stdenv, fetchFromGitHub, qt4, qmake4Hook, zlib }:

stdenv.mkDerivation rec {
  name = "leocad-${version}";
  version = "17.07";

  src = fetchFromGitHub {
    owner = "leozide";
    repo = "leocad";
    rev = "v${version}";
    sha256 = "1j361pvxywi4nb2alhnnd4qpqrpg6503gbi17cadcdi434gbqbsd";
  };

  nativeBuildInputs = [ qmake4Hook ];
  buildInputs = [ qt4 zlib ];
  postPatch = ''
    export qmakeFlags="$qmakeFlags INSTALL_PREFIX=$out"
  '';

  meta = with stdenv.lib; {
    description = "CAD program for creating virtual LEGO models";
    homepage = http://www.leocad.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
