{stdenv, fetchurl, fltk13, ghostscript}:

stdenv.mkDerivation {
  name = "flpsed-0.7.0";

  src = fetchurl {
    url = "http://www.ecademix.com/JohannesHofmann/flpsed-0.7.0.tar.gz";
    sha1 = "7966fd3b6fb3aa2a376386533ed4421ebb66ad62";
  };

  buildInputs = [ fltk13 ghostscript ];

  meta = {
    description = "WYSIWYG PostScript annotator";
    homepage = "http://http://flpsed.org/flpsed.html";
    license = "GPLv3";
    platforms = stdenv.lib.platforms.all;
  };

}
