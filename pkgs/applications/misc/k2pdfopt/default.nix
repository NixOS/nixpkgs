{ stdenv, fetchzip, fetchurl, fetchpatch, cmake, pkgconfig
, zlib, libpng, openjpeg
, enableGSL ? true, gsl
, enableGhostScript ? true, ghostscript
, enableMuPDF ? true, mupdf
, enableJPEG2K ? true, jasper
, enableDJVU ? true, djvulibre
, enableGOCR ? false, gocr # Disabled by default due to crashes
, enableTesseract ? true, leptonica, tesseract4
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "k2pdfopt-${version}";
  version = "2.51a";

  src = (fetchzip {
    url = "http://www.willus.com/k2pdfopt/src/k2pdfopt_v2.51_src.zip";
    sha256 = "133l7xkvi67s6sfk8cfh7rmavbsf7ib5fyksk1ci6b6sch3z2sw9";
  });

  # Note: the v2.51a zip contains only files to be replaced in the v2.50 zip.
  v251a_src = (fetchzip {
    url = "http://www.willus.com/k2pdfopt/src/k2pdfopt_v2.51a_src.zip";
    sha256 = "0vvwblii7kgdwfxw8dzk6jbmz4dv94d7rkv18i60y8wkayj6yhl6";
  });

  postUnpack = ''
    cp -r ${v251a_src}/* $sourceRoot
  '';

  patches = [ ./k2pdfopt.patch ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs =
  let
    mupdf_modded = mupdf.overrideAttrs (attrs: {
      # Excluded the pdf-*.c files, since they mostly just broke the #includes
      prePatch = ''
        cp ${src}/mupdf_mod/{font,stext-device,string}.c source/fitz/
        cp ${src}/mupdf_mod/font-win32.c source/pdf/
      '';
    });

    leptonica_modded = leptonica.overrideAttrs (attrs: {
      name = "leptonica-1.74.4";
      # Modified source files apply to this particular version of leptonica
      version = "1.74.4";

      src = fetchurl {
        url = "http://www.leptonica.org/source/leptonica-1.74.4.tar.gz";
        sha256 = "0fw39amgyv8v6nc7x8a4c7i37dm04i6c5zn62d24bgqnlhk59hr9";
      };

      prePatch = ''
        cp ${src}/leptonica_mod/{allheaders.h,dewarp2.c,leptwin.c} src/
      '';
      patches = [];
    });
    tesseract_modded = tesseract4.override {
      tesseractBase = tesseract4.tesseractBase.overrideAttrs (_: {
        prePatch = ''
          cp ${src}/tesseract_mod/baseapi.{h,cpp} src/api/
          cp ${src}/tesseract_mod/ccutil.{h,cpp} src/ccutil/
          cp ${src}/tesseract_mod/genericvector.h src/ccutil/
          cp ${src}/tesseract_mod/input.cpp src/lstm/
          cp ${src}/tesseract_mod/lstmrecognizer.cpp src/lstm/
          cp ${src}/tesseract_mod/mainblk.cpp src/ccutil/
          cp ${src}/tesseract_mod/params.cpp src/ccutil/
          cp ${src}/tesseract_mod/serialis.{h,cpp} src/ccutil/
          cp ${src}/tesseract_mod/tesscapi.cpp src/api/
          cp ${src}/tesseract_mod/tessdatamanager.cpp src/ccstruct/
          cp ${src}/tesseract_mod/tessedit.cpp src/ccmain/
          cp ${src}/include_mod/{tesseract.h,leptonica.h} src/api/
        '';
        patches = [ ./tesseract.patch ];
      });
    };
  in
    [ zlib libpng ] ++
    optional enableGSL gsl ++
    optional enableGhostScript ghostscript ++
    optional enableMuPDF mupdf_modded ++
    optional enableJPEG2K jasper ++
    optional enableDJVU djvulibre ++
    optional enableGOCR gocr ++
    optionals enableTesseract [ leptonica_modded tesseract_modded ];

  dontUseCmakeBuildDir = true;

  cmakeFlags = [ "-DCMAKE_C_FLAGS=-I${src}/include_mod" ];

  NIX_LDFLAGS = [
    "-lpthread"
  ];

  installPhase = ''
    install -D -m 755 k2pdfopt $out/bin/k2pdfopt
  '';

  meta = with stdenv.lib; {
    description = "Optimizes PDF/DJVU files for mobile e-readers (e.g. the Kindle) and smartphones";
    homepage = http://www.willus.com/k2pdfopt;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bosu danielfullmer ];
  };
}

