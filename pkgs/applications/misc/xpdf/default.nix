{ enableGUI ? true, enablePDFtoPPM ? true, useT1Lib ? true
, stdenv, fetchurl, x11 ? null, motif ? null, freetype ? null, t1lib ? null
, base14Fonts ? null
}:

assert enableGUI -> x11 != null && motif != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;
assert useT1Lib -> t1lib != null;

stdenv.mkDerivation {
  name = "xpdf-3.03";

  src = fetchurl {
    url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.03.tar.gz;
    sha256 = "1jnfzdqc54wa73lw28kjv0m7120mksb0zkcn81jdlvijyvc67kq2";
  };

  buildInputs =
    (if enableGUI then [x11 motif] else []) ++
    (if useT1Lib then [t1lib] else []);

  # Debian uses '-fpermissive' to bypass some errors on char* constantness.
  CXXFLAGS = "-O2 -fpermissive";

  configureFlags =
    "--infodir=$out/share/info --mandir=$out/share/man --enable-a4-paper"
    + (if enablePDFtoPPM then
         " --with-freetype2-library=${freetype}/lib"
         + " --with-freetype2-includes=${freetype}/include/freetype2"
       else "");

  postInstall = "
    if test -n \"${base14Fonts}\"; then
      substituteInPlace $out/etc/xpdfrc \\
        --replace /usr/local/share/ghostscript/fonts ${base14Fonts} \\
        --replace '#fontFile' fontFile
    fi
  ";

  meta = {
    homepage = "http://www.foolabs.com/xpdf/";
    description = "viewer for Portable Document Format (PDF) files";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
