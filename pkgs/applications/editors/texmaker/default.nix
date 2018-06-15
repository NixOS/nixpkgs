{ stdenv, fetchurl, qtbase, qtscript, qmake, zlib, pkgconfig, poppler }:

stdenv.mkDerivation rec {
  pname = "texmaker";
  version = "5.0.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/${name}.tar.bz2";
    sha256 = "0y81mjm89b99pr9svcwpaf4iz2q9pc9hjas5kiwd1pbgl5vqskm9";
  };

  buildInputs = [ qtbase qtscript poppler zlib ];
  nativeBuildInputs = [ pkgconfig poppler qmake ];
  NIX_CFLAGS_COMPILE="-I${poppler.dev}/include/poppler";

  preConfigure = ''
    qmakeFlags="$qmakeFlags DESKTOPDIR=$out/share/applications ICONDIR=$out/share/pixmaps METAINFODIR=$out/share/metainfo"
  '';


  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
	This editor is a full fledged IDE for TeX and
	LaTeX editing with completion, structure viewer, preview,
	spell checking and support of any compilation chain.
	'';
    homepage = http://www.xm1math.net/texmaker/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cfouche ];
  };
}
