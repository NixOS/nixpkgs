{ stdenv, fetchFromGitHub,
  qmake, qtbase, qtxmlpatterns, qtsvg, qtscxml, qtquick1, libGLU }:

stdenv.mkDerivation rec {
  name = "qxmledit-${version}" ;
  version = "0.9.15" ;
  src = fetchFromGitHub ( stdenv.lib.importJSON ./qxmledit.json ) ;
  nativeBuildInputs = [ qmake ] ;
  buildInputs = [ qtbase qtxmlpatterns qtsvg qtscxml qtquick1 libGLU ] ;
  qmakeFlags = [ "CONFIG+=release" ] ;
  outputs = [ "out" "doc" ] ;

  preConfigure = ''
    export QXMLEDIT_INST_DATA_DIR="$out/share/data"
    export QXMLEDIT_INST_TRANSLATIONS_DIR="$out/share/i18n"
    export QXMLEDIT_INST_INCLUDE_DIR="$out/include"
    export QXMLEDIT_INST_DIR="$out/bin"
    export QXMLEDIT_INST_LIB_DIR="$out/lib"
    export QXMLEDIT_INST_DOC_DIR="$doc"
  '';

  meta = with stdenv.lib; {
    description = "Simple XML editor based on qt libraries" ;
    homepage = "https://sourceforge.net/projects/qxmledit";
    license = licenses.lgpl2;
    platforms = platforms.all;
  } ;
}
