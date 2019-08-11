/*
To use aditional parts libraries
set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

{ stdenv, fetchFromGitHub, qt4, qmake4Hook, zlib }:

stdenv.mkDerivation rec {
  name = "leocad-${version}";
  version = "19.07.1";

  src = fetchFromGitHub {
    owner = "leozide";
    repo = "leocad";
    rev = "v${version}";
    sha256 = "02kv1m18g6s4dady9jv4sjivfkrp192bmdw2a3d9lzlp60zks0p2";
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
