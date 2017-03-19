/*
To use aditional parts libraries
set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

{ stdenv, fetchFromGitHub, qt4, qmake4Hook, zlib }:

stdenv.mkDerivation rec {
  name = "leocad-${version}";
  version = "17.02";

  src = fetchFromGitHub {
    owner = "leozide";
    repo = "leocad";
    rev = "v${version}";
    sha256 = "0d7l2il6r4swnmrmaf1bsrgpjgai5xwhwk2mkpcsddnk59790mmc";
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
    inherit (qt4.meta) platforms;
  };
}
