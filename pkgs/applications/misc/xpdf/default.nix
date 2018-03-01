{ enableGUI ? true, enablePDFtoPPM ? true, useT1Lib ? false
, stdenv, fetchurl, zlib, libpng, freetype ? null, t1lib ? null
, cmake, qtbase ? null, makeWrapper
}:

assert enableGUI -> qtbase != null && freetype != null;
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

  nativeBuildInputs = [ cmake makeWrapper ];

  cmakeFlags = ["-DSYSTEM_XPDFRC=/etc/xpdfrc" "-DA4_PAPER=ON"];

  buildInputs = [ zlib libpng ] ++
    stdenv.lib.optional enableGUI qtbase ++
    stdenv.lib.optional useT1Lib t1lib ++
    stdenv.lib.optional enablePDFtoPPM freetype;

  # Debian uses '-fpermissive' to bypass some errors on char* constantness.
  CXXFLAGS = "-O2 -fpermissive";

  hardeningDisable = [ "format" ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    wrapProgram $out/bin/xpdf \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase.bin}/lib/qt-*/plugins/platforms
  '';

  meta = {
    homepage = http://www.foolabs.com/xpdf/;
    description = "Viewer for Portable Document Format (PDF) files";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
