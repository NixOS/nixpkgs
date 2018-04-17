/*
To use aditional parts libraries
set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

{ stdenv, fetchFromGitHub, qt4, qmake4Hook, zlib }:

stdenv.mkDerivation rec {
  name = "leocad-${version}";
  version = "18.02";

  src = fetchFromGitHub {
    owner = "leozide";
    repo = "leocad";
    rev = "v${version}";
    sha256 = "0rb4kjyrr9ry85cfpbk52l19vvwn7lrh2kmj2lwq531smnygn5m3";
  };

  nativeBuildInputs = [ qmake4Hook ];
  buildInputs = [ qt4 zlib ];
  postPatch = ''
    export qmakeFlags="$qmakeFlags INSTALL_PREFIX=$out"
  '';

  meta = with stdenv.lib; {
    description = "CAD program for creating virtual LEGO models";
    homepage = https://www.leocad.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
