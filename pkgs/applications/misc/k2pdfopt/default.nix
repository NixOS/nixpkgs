{ stdenv, fetchzip, fetchurl, fetchpatch, cmake, pkgconfig
, zlib, libpng
, enableGSL ? true, gsl
, enableGhostScript ? true, ghostscript
, enableMuPDF ? true, mupdf
, enableJPEG2K ? false, jasper ? null  # disabled by default, jasper has unfixed CVE
, enableDJVU ? true, djvulibre
, enableGOCR ? false, gocr # Disabled by default due to crashes
, enableTesseract ? true, leptonica, tesseract4
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "k2pdfopt";
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

  patches = [ ./k2pdfopt.patch ./k2pdfopt-mupdf-1.16.1.patch ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs =
  let
    #  The patches below were constructed by taking the files from k2pdfopt in
    #  the {mupdf,leptonica,tesseract}_mod/ directories, replacing the
    #  corresponding files in the respective source trees, resolving any errors
    #  with more recent versions of these depencencies, and running diff.
    mupdf_modded = mupdf.overrideAttrs (attrs: {
      patches = attrs.patches ++ [ ./mupdf.patch ]; # Last verified with mupdf 1.16.1
    });
    leptonica_modded = leptonica.overrideAttrs (attrs: {
      patches = [ ./leptonica.patch ]; # Last verified with leptonica 1.78.0
    });
    tesseract_modded = tesseract4.override {
      tesseractBase = tesseract4.tesseractBase.overrideAttrs (_: {
        patches = [ ./tesseract.patch ]; # Last verified with tesseract 1.4
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

  NIX_LDFLAGS = "-lpthread";

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

