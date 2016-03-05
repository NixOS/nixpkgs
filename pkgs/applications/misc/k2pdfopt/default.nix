# Build procedure lifted from https://aur.archlinux.org/packages/k2/k2pdfopt/PKGBUILD
{ stdenv, fetchzip, fetchurl, writeScript, libX11, libXext, autoconf, automake, libtool
      , leptonica, libpng, libtiff, zlib, openjpeg, freetype, jbig2dec, djvulibre
      , openssl }:

let
  mupdf_src = fetchurl {
    url = http://www.mupdf.com/downloads/archive/mupdf-1.6-source.tar.gz;
    sha256 = "0qx51rj6alzcagcixm59rvdpm54w6syrwr4184v439jh14ryw4wq";
  };

  tess_src = fetchurl {
    url = http://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02.tar.gz;
    sha256 = "0g81m9y4iydp7kgr56mlkvjdwpp3mb01q385yhdnyvra7z5kkk96";
  };

  gocr_src = fetchurl {
    url = http://www-e.uni-magdeburg.de/jschulen/ocr/gocr-0.49.tar.gz;
    sha256 = "06hpzp7rkkwfr1fvmc8kcfz9v490i9yir7f7imh13gmka0fr6afc";
  };

in stdenv.mkDerivation rec {
  name = "k2pdfopt-${version}";
  version = "2.32";
  src = fetchzip {
    url = "http://www.willus.com/k2pdfopt/src/k2pdfopt_v${version}_src.zip";
    sha256 = "1v3cj5bwpjvy7s66sfqcmkxs91f7nxaykjpdjm2wn87vn6q7n19m";
  };

  buildInputs = [ libX11 libXext autoconf automake libtool leptonica libpng libtiff zlib
                    openjpeg freetype jbig2dec djvulibre openssl ];
  NIX_LDFLAGS = "-lX11 -lXext";

  hardeningDisable = [ "format" ];

  k2_pa = ./k2pdfopt.patch;
  tess_pa = ./tesseract.patch;

  builder = writeScript "builder.sh" ''
    . ${stdenv}/setup
    set -e

    plibs=`pwd`/patched_libraries

    tar zxf ${mupdf_src}
    cp $src/mupdf_mod/font.c $src/mupdf_mod/string.c mupdf-1.6-source/source/fitz/
    cp $src/mupdf_mod/pdf-* mupdf-1.6-source/source/pdf

    tar zxf ${tess_src}
    cp $src/tesseract_mod/dawg.cpp tesseract-ocr/dict
    cp $src/tesseract_mod/tessdatamanager.cpp tesseract-ocr/ccutil
    cp $src/tesseract_mod/tessedit.cpp tesseract-ocr/ccmain
    cp $src/tesseract_mod/tesscapi.cpp tesseract-ocr/api
    cp $src/include_mod/tesseract.h $src/include_mod/leptonica.h tesseract-ocr/api

    cp -a $src k2pdfopt_v2.21
    chmod -R +w k2pdfopt_v2.21

    patch -p0 -i $tess_pa
    patch -p0 -i $k2_pa

    cd tesseract-ocr
    ./autogen.sh
    substituteInPlace "configure" \
            --replace 'LIBLEPT_HEADERSDIR="/usr/local/include /usr/include"' \
            'LIBLEPT_HEADERSDIR=${leptonica}/include'
    ./configure --prefix=$plibs --disable-shared
    make install

    cd ..
    tar zxf ${gocr_src}
    cd gocr-0.49
    ./configure
    cp src/{gocr.h,pnm.h,unicode.h,list.h} $plibs/include
    cp include/config.h $plibs/include
    make libs
    cp src/libPgm2asc.a $plibs/lib

    cd ../mupdf-1.6-source
    make prefix=$plibs install
    install -Dm644 build/debug/libmujs.a $plibs/lib

    cd ../k2pdfopt_v2.21/k2pdfoptlib
    gcc -Ofast -Wall -c *.c -I ../include_mod/ -I $plibs/include \
        -I . -I ../willuslib
    ar rcs libk2pdfopt.a *.o

    cd ../willuslib
    gcc -Ofast -Wall -c *.c -I ../include_mod/ -I $plibs/include
    ar rcs libwillus.a *.o

    cd ..
    gcc -Wall -Ofast -o k2pdfopt.o -c k2pdfopt.c -I k2pdfoptlib/ -I willuslib/ \
            -I include_mod/ -I $plibs/include
    g++ -Ofast k2pdfopt.o -o k2pdfopt -I willuslib/ -I k2pdfoptlib/ -I include_mod/ \
            -I $plibs/include -L $plibs/lib/ \
            -L willuslib/ -L k2pdfoptlib/ -lk2pdfopt -lwillus -ldjvulibre -lz -lmupdf  \
            -ljbig2dec -ljpeg -lopenjp2 -lpng -lfreetype -lpthread -lmujs \
            -lPgm2asc -llept -ltesseract -lcrypto

    mkdir -p $out/bin
    cp k2pdfopt $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Optimizes PDF/DJVU files for mobile e-readers (e.g. the Kindle) and smartphones";
    homepage = http://www.willus.com/k2pdfopt;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bosu ];
  };
}

