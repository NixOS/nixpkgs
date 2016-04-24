{ stdenv, fetchurl, qt4, qmake4Hook, poppler_qt4, zlib, pkgconfig, poppler }:

stdenv.mkDerivation rec {
  pname = "texmaker";
  version = "4.4.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/${name}.tar.bz2";
    sha256 = "1d5lb4sibdhvzgfr0zi48j92b4acvvvdy2biqi3jzjdnzy9r94w0";
  };

  buildInputs = [ qt4 poppler_qt4 zlib ];
  nativeBuildInputs = [ pkgconfig poppler qmake4Hook ];
  NIX_CFLAGS_COMPILE="-I${poppler}/include/poppler";

  preConfigure = ''
    qmakeFlags="$qmakeFlags DESKTOPDIR=$out/share/applications ICONDIR=$out/share/pixmaps"
  '';

  meta = with stdenv.lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
	This editor is a full fledged IDE for TeX and
	LaTeX editing with completion, structure viewer, preview,
	spell checking and support of any compilation chain.
	'';
    homepage = "http://www.xm1math.net/texmaker/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cfouche ];
  };
}
