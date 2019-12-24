{ lib, mkDerivation, fetchurl, qtbase, qtscript, qmake, zlib, pkgconfig, poppler }:

mkDerivation rec {
  pname = "texmaker";
  version = "5.0.3";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/${pname}-${version}.tar.bz2";
    sha256 = "0vrj9w5lk3vf6138n5bz8phmy3xp5kv4dq1rgirghcf4hbxdyx30";
  };

  buildInputs = [ qtbase qtscript poppler zlib ];
  nativeBuildInputs = [ pkgconfig poppler qmake ];
  NIX_CFLAGS_COMPILE="-I${poppler.dev}/include/poppler";

  preConfigure = ''
    qmakeFlags="$qmakeFlags DESKTOPDIR=$out/share/applications ICONDIR=$out/share/pixmaps METAINFODIR=$out/share/metainfo"
  '';


  enableParallelBuilding = true;

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
	This editor is a full fledged IDE for TeX and
	LaTeX editing with completion, structure viewer, preview,
	spell checking and support of any compilation chain.
	'';
    homepage = http://www.xm1math.net/texmaker/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cfouche markuskowa ];
  };
}
