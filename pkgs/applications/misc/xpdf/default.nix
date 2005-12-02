{ enableGUI ? true, enablePDFtoPPM ? true
, stdenv, fetchurl, x11 ? null, motif ? null, freetype ? null
}:

assert enableGUI -> x11 != null && motif != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;

stdenv.mkDerivation {
  name = "xpdf-3.01";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.01.tar.gz;
    md5 = "e004c69c7dddef165d768b1362b44268";
  };
  
  buildInputs = (if enableGUI then [x11 motif] else []);
  freetype = if enableGUI || enablePDFtoPPM then freetype else null;
    
  configureFlags = "--enable-a4-paper"; /* We obey ISO standards! */
}
