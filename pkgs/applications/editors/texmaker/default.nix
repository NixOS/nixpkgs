{ lib, mkDerivation, fetchurl, qtbase, qtscript, qtwebengine, qmake, zlib, pkg-config, poppler }:

mkDerivation rec {
  pname = "texmaker";
  version = "5.1.1";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/${pname}-${version}.tar.bz2";
    sha256 = "sha256-gANJknSWIMN+B0uAOtPil8EbjyWt4E+xOxOseR87Dd4=";
  };

  buildInputs = [ qtbase qtscript poppler zlib qtwebengine ];
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
