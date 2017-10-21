{ enableGUI ? true, enablePDFtoPPM ? true, useT1Lib ? false
, stdenv, fetchurl, zlib, libpng, freetype ? null, t1lib ? null
, cmake, qtbase ? null
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

  nativeBuildInputs = [ cmake ];

  cmakeFlags = ["-DSYSTEM_XPDFRC=/etc/xpdfrc" "-DA4_PAPER=ON"];

  buildInputs = [ zlib libpng ] ++
    stdenv.lib.optional enableGUI qtbase ++
    stdenv.lib.optional useT1Lib t1lib ++
    stdenv.lib.optional enablePDFtoPPM freetype;

  # Debian uses '-fpermissive' to bypass some errors on char* constantness.
  CXXFLAGS = "-O2 -fpermissive";

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://www.foolabs.com/xpdf/;
    description = "Viewer for Portable Document Format (PDF) files";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
