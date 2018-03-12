{ stdenv, fetchurl, qt5, poppler_qt5, zlib, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "texstudio";
  version = "2.12.6";
  name = "${pname}-${version}";
  altname="Texstudio";

  src = fetchurl {
    url = "mirror://sourceforge/texstudio/${name}.tar.gz";
    sha256 = "18rxd7ra5k2f7s4c296b3v3pqhxjmfix9xpy9i1g4jm87ygqrbnd";
  };

  nativeBuildInputs = [ qt5.qmake pkgconfig ];
  buildInputs = [ qt5.qtbase qt5.qtscript qt5.qtsvg poppler_qt5 zlib ];

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
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cfouche ];
  };
}
