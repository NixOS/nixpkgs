{ lib
, mkDerivation
, fetchurl
, pkg-config
, cairo
, freetype
, ghostscript
, gsl
, libjpeg
, libpng
, libspiro
, lua5
, qtbase
, texlive
, zlib
}:

mkDerivation rec {
  pname = "ipe";
  version = "7.2.23";

  src = fetchurl {
    url = "https://dl.bintray.com/otfried/generic/ipe/7.2/${pname}-${version}-src.tar.gz";
    sha256 = "0yvm3zfba1ljyy518vjnvwpyg7lgnmdwm19v5k0wfgz64aca56x1";
  };

  sourceRoot = "${pname}-${version}/src";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    cairo
    freetype
    ghostscript
    gsl
    libjpeg
    libpng
    libspiro
    lua5
    qtbase
    texlive
    zlib
  ];

  IPEPREFIX=placeholder "out";
  URWFONTDIR="${texlive}/texmf-dist/fonts/type1/urw/";
  LUA_PACKAGE = "lua";

  qtWrapperArgs = [ "--prefix PATH : ${texlive}/bin"  ];

  enableParallelBuilding = true;

  # TODO: make .desktop entry

  meta = with lib; {
    description = "An editor for drawing figures";
    homepage = "http://ipe.otfried.org";  # https not available
    license = licenses.gpl3Plus;
    longDescription = ''
      Ipe is an extensible drawing editor for creating figures in PDF and Postscript format.
      It supports making small figures for inclusion into LaTeX-documents
      as well as presentations in PDF.
    '';
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.linux;
  };
}
