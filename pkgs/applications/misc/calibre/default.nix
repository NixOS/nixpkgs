{ stdenv, fetchurl, python, pyqt4, sip, popplerQt4, pkgconfig, libpng
, imagemagick, libjpeg, fontconfig, podofo, qt48, icu, sqlite
, pil, makeWrapper, unrar, chmlib, pythonPackages, xz, libusb1, libmtp
}:

stdenv.mkDerivation rec {
  name = "calibre-1.11.0";

  src = fetchurl {
    url = "mirror://sourceforge/calibre/${name}.tar.xz";
    sha256 = "17jp93wzq11yb89yg2x42f65yyx6v0hy6nhvrd42ig0vhk7sdh2n";
  };

  inherit python;

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  patchPhase = ''
    tar xf ${qt48.src}
    qtdir=$(realpath $(ls | grep qt | grep 4.8 | grep src))
    sed -i setup/build_environment.py \
        -e "s|^qt_private_inc = .*|qt_private_inc = ['$qtdir/include/%s'%(m) for m in ('QtGui', 'QtCore')]|"
  '';

  buildInputs =
    [ python pyqt4 sip popplerQt4 libpng imagemagick libjpeg
      fontconfig podofo qt48 pil chmlib icu sqlite libusb1 libmtp
      pythonPackages.mechanize pythonPackages.lxml pythonPackages.dateutil
      pythonPackages.cssutils pythonPackages.beautifulsoup pythonPackages.pillow
      pythonPackages.sqlite3 pythonPackages.netifaces pythonPackages.apsw
      pythonPackages.cssselect
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

    sed -i "s/env python[0-9.]*/python/" $PYFILES
    for a in $out/bin/*; do
      wrapProgram $a --prefix PYTHONPATH : $PYTHONPATH --prefix LD_LIBRARY_PATH : ${unrar}/lib --prefix PATH : ${popplerQt4}/bin
    done
  '';

  meta = with stdenv.lib; {
    description = "Comprehensive e-book software";
    homepage = http://calibre-ebook.com;
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric iElectric ];
    platforms = platforms.linux;
  };
}
