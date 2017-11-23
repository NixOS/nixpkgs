{ stdenv, fetchurl, qt4, qmake4Hook, poppler_qt4, zlib, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "texstudio";
  version = "2.12.6";
  name = "${pname}-${version}";
  altname="Texstudio";

  src = fetchurl {
    url = "mirror://sourceforge/texstudio/${name}.tar.gz";
    sha256 = "18rxd7ra5k2f7s4c296b3v3pqhxjmfix9xpy9i1g4jm87ygqrbnd";
  };

  nativeBuildInputs = [ qmake4Hook pkgconfig ];
  buildInputs = [ qt4 poppler_qt4 zlib ];

  qmakeFlags = [ "NO_APPDATA=True" ];

  meta = with stdenv.lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
	Fork of TeXMaker, this editor is a full fledged IDE for
	LaTeX editing with completion, structure viewer, preview,
	spell checking and support of any compilation chain.
	'';
    homepage = http://texstudio.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cfouche ];
  };
}
