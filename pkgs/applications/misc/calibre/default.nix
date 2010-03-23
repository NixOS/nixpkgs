{ stdenv, fetchurl, python, pyqt4, sip, popplerQt4, pkgconfig, libpng
, imagemagick, libjpeg, fontconfig, podofo, qt4, mechanize, lxml, dateutil
, pil, cssutils, beautifulsoap, makeWrapper, unrar
}:

stdenv.mkDerivation rec {
  name = "calibre-0.6.43";

  src = fetchurl {
    url = "mirror://sourceforge/calibre/${name}.tar.gz";
    sha256 = "1fqrishm5na2h0jh46w1gj7gvav335fixwrk6y7l7l4a6argjslr";
  };

  inherit python;

  buildInputs =
    [ python pyqt4 sip popplerQt4 pkgconfig libpng imagemagick libjpeg
      fontconfig podofo qt4 mechanize lxml dateutil pil makeWrapper
      cssutils beautifulsoap
    ];

  installPhase = ''
    export HOME=$TMPDIR/fakehome
    export POPPLER_INC_DIR=${popplerQt4}/include/poppler
    export POPPLER_LIB_DIR=${popplerQt4}/lib
    export MAGICK_INC=${imagemagick}/include/ImageMagick
    export MAGICK_LIB=${imagemagick}/lib
    export FC_INC_DIR=${fontconfig}/include/fontconfig
    export FC_LIB_DIR=${fontconfig}/lib
    export PODOFO_INC_DIR=${podofo}/include/podofo
    export PODOFO_LIB_DIR=${podofo}/lib
    python setup.py install --prefix=$out

    PYFILES="$out/bin/* $out/lib/calibre/calibre/web/feeds/*.py
      $out/lib/calibre/calibre/ebooks/metadata/*.py
      $out/lib/calibre/calibre/ebooks/rtf2xml/*.py"

    sed -i "s/env python/python/" $PYFILES
    for a in $out/bin/*; do
      wrapProgram $a --prefix PYTHONPATH : $PYTHONPATH --prefix LD_LIBRARY_PATH : ${unrar}/lib
    done
  '';

  meta = { 
    description = "Comprehensive e-book software";
    homepage = http://calibre-ebook.com;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
