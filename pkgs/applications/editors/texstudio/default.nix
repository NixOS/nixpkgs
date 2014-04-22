{ stdenv, fetchurl, qt, popplerQt4, phonon }:

stdenv.mkDerivation rec {
  pname = "texstudio";
  version = "2.7.0";
  name = "${pname}-${version}";
  altname="Texstudio";

  src = fetchurl {
    url = "mirror://sourceforge/texstudio/${altname} ${version}/${name}.tar.gz";
    sha1 = "0a5960689f2f9daef93391b96321ccc8c2e94c38";
  };

  buildInputs = [ qt popplerQt4 phonon ];

  preConfigure = "qmake -r PREFIX=$out";

  meta = with stdenv.lib; {
    description = "Fork of TeXMaker, this editor is a full fledged IDE for LaTeX editing with completion, structure viewer, preview and support of any compilation chain.";
    homepage = "http://texstudio.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
