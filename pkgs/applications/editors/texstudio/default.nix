{ stdenv, fetchurl, qt, popplerQt4, zlib}:

stdenv.mkDerivation rec {
  pname = "texstudio";
  version = "2.7.0";
  name = "${pname}-${version}";
  altname="Texstudio";

  src = fetchurl {
    url = "mirror://sourceforge/texstudio/${name}.tar.gz";
    sha256 = "167d78nfk265jjvl129nr70v8ladb2rav2qyhw7ngr6m54gak831";
  };

  buildInputs = [ qt popplerQt4 zlib ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(echo ${popplerQt4}/include/poppler/qt4) "
    qmake PREFIX=$out texstudio.pro
  '';

  meta = with stdenv.lib; {
    description = "Fork of TeXMaker, this editor is a full fledged IDE for LaTeX editing with completion, structure viewer, preview and support of any compilation chain.";
    homepage = "http://texstudio.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
