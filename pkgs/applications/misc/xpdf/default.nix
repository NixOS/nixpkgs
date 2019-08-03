{ enableGUI ? true, enablePDFtoPPM ? true, useT1Lib ? false
, stdenv, fetchurl, zlib, libpng, freetype ? null, t1lib ? null
, cmake, qtbase ? null, qtsvg ? null, wrapQtAppsHook
}:

assert enableGUI -> qtbase != null && qtsvg != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;
assert useT1Lib -> t1lib != null;

assert !useT1Lib; # t1lib has multiple unpatched security vulnerabilities

stdenv.mkDerivation {
  name = "xpdf-4.00";

   src = fetchurl {
    url = http://www.xpdfreader.com/dl/xpdf-4.00.tar.gz;
    sha256 = "1mhn89738vjva14xr5gblc2zrdgzmpqbbjdflqdmpqv647294ggz";
  };

  # Fix "No known features for CXX compiler", see
  # https://cmake.org/pipermail/cmake/2016-December/064733.html and the note at
  # https://cmake.org/cmake/help/v3.10/command/cmake_minimum_required.html
  patches = stdenv.lib.optional stdenv.isDarwin  ./cmake_version.patch;

  nativeBuildInputs =
    [ cmake ]
    ++ stdenv.lib.optional enableGUI wrapQtAppsHook;

  cmakeFlags = ["-DSYSTEM_XPDFRC=/etc/xpdfrc" "-DA4_PAPER=ON"];

  buildInputs = [ zlib libpng ] ++
    stdenv.lib.optional enableGUI qtbase ++
    stdenv.lib.optional useT1Lib t1lib ++
    stdenv.lib.optional enablePDFtoPPM freetype;

  # Debian uses '-fpermissive' to bypass some errors on char* constantness.
  CXXFLAGS = "-O2 -fpermissive";

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://www.xpdfreader.com;
    description = "Viewer for Portable Document Format (PDF) files";
    longDescription = ''
      XPDF includes multiple tools for viewing and processing PDF files.
        xpdf:      PDF viewer (with Graphical Interface)
        pdftotext: converts PDF to text
        pdftops:   converts PDF to PostScript
        pdftoppm:  converts PDF pages to netpbm (PPM/PGM/PBM) image files
        pdftopng:  converts PDF pages to PNG image files
        pdftohtml: converts PDF to HTML
        pdfinfo:   extracts PDF metadata
        pdfimages: extracts raw images from PDF files
        pdffonts:  lists fonts used in PDF files
        pdfdetach: extracts attached files from PDF files
    '';
    license = with licenses; [ gpl2 gpl3 ];
    platforms = platforms.unix;
  };
}
