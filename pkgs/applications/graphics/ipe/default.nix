{ stdenv, fetchurl, pkgconfig, zlib, qt4, freetype, cairo, lua5, texLive, ghostscriptX
, makeWrapper }:
let ghostscript = ghostscriptX; in
stdenv.mkDerivation rec {
  name = "ipe-7.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/ipe7/ipe/7.1.0/${name}-src.tar.gz";
    sha256 = "04fs5slci3bmpgz8d038h3hnzzdw57xykcpsmisdxci2xrkxx41k";
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

  IPEPREFIX="$$out";
  URWFONTDIR="${texLive}/texmf-dist/fonts/type1/urw/";

  buildInputs = [
    pkgconfig zlib qt4 freetype cairo lua5 texLive ghostscript makeWrapper
  ];

  postInstall = ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix PATH : "${texLive}/bin"
    done
  '';

  #TODO: make .desktop entry

  meta = {
    description = "An editor for drawing figures";
    homepage = http://ipe7.sourceforge.net;
    license = "GPLv3+";
    longDescription = ''
      Ipe is an extensible drawing editor for creating figures in PDF and Postscript format.
      It supports making small figures for inclusion into LaTeX-documents
      as well as presentations in PDF.
    '';
  };
}
