{ enableGUI ? true
, enablePDFtoPPM ? true
, enablePrinting ? true
, stdenv, fetchzip, cmake, makeDesktopItem
, zlib, libpng, cups ? null, freetype ? null
, qtbase ? null, qtsvg ? null, wrapQtAppsHook
}:

assert enableGUI -> qtbase != null && qtsvg != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;
assert enablePrinting -> cups != null;

stdenv.mkDerivation rec {
  pname = "xpdf";
  version = "4.02";

  src = fetchzip {
    url = "https://xpdfreader-dl.s3.amazonaws.com/${pname}-${version}.tar.gz";
    sha256 = "0dzwq6fnk013wa4l5mjpvm4mms2mh5hbrxv4rhk2ab5ljbzz7b2w";
  };

  # Fix "No known features for CXX compiler", see
  # https://cmake.org/pipermail/cmake/2016-December/064733.html and the note at
  # https://cmake.org/cmake/help/v3.10/command/cmake_minimum_required.html
  patches = stdenv.lib.optional stdenv.isDarwin  ./cmake_version.patch;

  nativeBuildInputs =
    [ cmake ]
    ++ stdenv.lib.optional enableGUI wrapQtAppsHook;

  cmakeFlags = ["-DSYSTEM_XPDFRC=/etc/xpdfrc" "-DA4_PAPER=ON" "-DOPI_SUPPORT=ON"]
    ++ stdenv.lib.optional (!enablePrinting) "-DXPDFWIDGET_PRINTING=OFF";

  buildInputs = [ zlib libpng ] ++
    stdenv.lib.optional enableGUI qtbase ++
    stdenv.lib.optional enablePrinting cups ++
    stdenv.lib.optional enablePDFtoPPM freetype;

  hardeningDisable = [ "format" ];

  desktopItem = makeDesktopItem {
    name = "xpdf";
    desktopName = "Xpdf";
    comment = "Views Adobe PDF files";
    icon = "xpdf";
    exec = "xpdf %f";
    categories = "Office;";
    terminal = "false";
  };

  postInstall = ''
    install -Dm644 ${desktopItem}/share/applications/xpdf.desktop $out/share/applications/xpdf.desktop
    install -Dm644 $src/xpdf-qt/xpdf-icon.svg $out/share/pixmaps/xpdf.svg
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.xpdfreader.com";
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
    maintainers = with maintainers; [ sikmir ];
    knownVulnerabilities = [
      "CVE-2018-7453: loop in PDF objects"
      "CVE-2018-16369: loop in PDF objects"
      "CVE-2019-9587: loop in PDF objects"
      "CVE-2019-9588: loop in PDF objects"
      "CVE-2019-16088: loop in PDF objects"
    ];
  };
}
