{ stdenv, fetchurl, qt4, popplerQt4, zlib, pkgconfig, poppler}:

stdenv.mkDerivation rec {
  pname = "texmaker";
  version = "4.1.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/${name}.tar.bz2";
    sha256 = "1h5rxdq6f05wk3lnlw96fxwrb14k77cx1mwy648127h2c8nsgw4z";
  };

  buildInputs = [ qt4 popplerQt4 zlib ];

  nativeBuildInputs = [ pkgconfig poppler ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(echo ${poppler}/include/poppler/) " # for poppler-config.h
    qmake PREFIX=$out DESKTOPDIR=$out/share/applications ICONDIR=$out/share/pixmaps texmaker.pro
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
