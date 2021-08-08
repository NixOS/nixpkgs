{ lib, mkDerivation, fetchurl, qtbase, qtscript, qmake, zlib, pkg-config, poppler }:

mkDerivation rec {
  pname = "texmaker";
  version = "5.0.4";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/${pname}-${version}.tar.bz2";
    sha256 = "1qnh5g8zkjpjmw2l8spcynpfgs3wpcfcla5ms2kkgvkbdlzspqqx";
  };

  buildInputs = [ qtbase qtscript poppler zlib ];
  nativeBuildInputs = [ pkg-config poppler qmake ];
  NIX_CFLAGS_COMPILE="-I${poppler.dev}/include/poppler";

  qmakeFlags = [
    "DESKTOPDIR=${placeholder "out"}/share/applications"
    "ICONDIR=${placeholder "out"}/share/pixmaps"
    "METAINFODIR=${placeholder "out"}/share/metainfo"
  ];

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
      This editor is a full fledged IDE for TeX and
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "http://www.xm1math.net/texmaker/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cfouche markuskowa ];
  };
}
