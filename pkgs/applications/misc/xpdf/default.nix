{ enableGUI ? true, enablePDFtoPPM ? true, useT1Lib ? false
, stdenv, fetchurl, x11 ? null, motif ? null, freetype ? null, t1lib ? null
, base14Fonts ? null
}:

assert enableGUI -> x11 != null && motif != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;
assert useT1Lib -> t1lib != null;

assert !useT1Lib; # t1lib has multiple unpatched security vulnerabilities

stdenv.mkDerivation {
  name = "xpdf-3.03";

  src = fetchurl {
    url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.03.tar.gz;
    sha256 = "1jnfzdqc54wa73lw28kjv0m7120mksb0zkcn81jdlvijyvc67kq2";
  };

  buildInputs =
    stdenv.lib.optionals enableGUI [x11 motif] ++
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
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
