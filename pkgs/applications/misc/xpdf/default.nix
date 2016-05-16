{ enableGUI ? true, enablePDFtoPPM ? true, useT1Lib ? false
, stdenv, fetchurl, zlib, libpng, xlibsWrapper ? null, motif ? null, freetype ? null, t1lib ? null
, base14Fonts ? null
}:

assert enableGUI -> xlibsWrapper != null && motif != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;
assert useT1Lib -> t1lib != null;

assert !useT1Lib; # t1lib has multiple unpatched security vulnerabilities

stdenv.mkDerivation {
  name = "xpdf-3.04";

  src = fetchurl {
    url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.04.tar.gz;
    sha256 = "1rbp54mr3z2x3a3a1qmz8byzygzi223vckfam9ib5g1sfds0qf8i";
  };

  buildInputs = [ zlib libpng ] ++
    stdenv.lib.optionals enableGUI [xlibsWrapper motif] ++
    stdenv.lib.optional useT1Lib t1lib ++
    stdenv.lib.optional enablePDFtoPPM freetype;

  # Debian uses '-fpermissive' to bypass some errors on char* constantness.
  CXXFLAGS = "-O2 -fpermissive";

  configureFlags = "--enable-a4-paper";

  postInstall = stdenv.lib.optionalString (base14Fonts != null) ''
    substituteInPlace $out/etc/xpdfrc \
      --replace /usr/local/share/ghostscript/fonts ${base14Fonts} \
      --replace '#fontFile' fontFile
  '';

  meta = {
    homepage = "http://www.foolabs.com/xpdf/";
    description = "viewer for Portable Document Format (PDF) files";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
