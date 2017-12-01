{ stdenv, fetchurl, makeWrapper, pkgconfig, zlib, freetype, cairo, lua5, texlive, ghostscript
, libjpeg, qtbase
}:

stdenv.mkDerivation rec {
  name = "ipe-7.2.7";

  src = fetchurl {
    url = "https://dl.bintray.com/otfried/generic/ipe/7.2/${name}-src.tar.gz";
    sha256 = "08lzqhagvr8l69hxghyw9akf5dixbily7hj2gxhzzrp334k3yvfn";
  };

  # changes taken from Gentoo portage
  preConfigure = ''
    cd src
    sed -i \
      -e 's/fpic/fPIC/' \
      -e 's/moc-qt4/moc/' \
      config.mak || die
    sed -i -e 's/install -s/install/' common.mak || die
  '';

  NIX_CFLAGS_COMPILE = [ "-std=c++11" ]; # build with Qt 5.7

  IPEPREFIX="$$out";
  URWFONTDIR="${texlive}/texmf-dist/fonts/type1/urw/";
  LUA_PACKAGE = "lua";

  buildInputs = [
    libjpeg zlib qtbase freetype cairo lua5 texlive ghostscript
  ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  postFixup = ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix PATH : "${texlive}/bin"
    done
  '';

  patches = [ ./xlocale.patch ];

  #TODO: make .desktop entry

  meta = {
    description = "An editor for drawing figures";
    homepage = http://ipe.otfried.org;
    license = stdenv.lib.licenses.gpl3Plus;
    longDescription = ''
      Ipe is an extensible drawing editor for creating figures in PDF and Postscript format.
      It supports making small figures for inclusion into LaTeX-documents
      as well as presentations in PDF.
    '';
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.linux;
  };
}
