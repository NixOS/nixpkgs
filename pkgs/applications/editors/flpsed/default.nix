{stdenv, fetchurl, fltk13, ghostscript}:

stdenv.mkDerivation {
  name = "flpsed-0.7.1";

  src = fetchurl {
    url = "http://www.ecademix.com/JohannesHofmann/flpsed-0.7.1.tar.gz";
    sha256 = "16i3mjc1cdx2wiwfhnv3z2ywmjma9785vwl3l31izx9l51w7ngj3";
  };

  buildInputs = [ fltk13 ghostscript ];

  meta = {
    description = "WYSIWYG PostScript annotator";
    homepage = "http://http://flpsed.org/flpsed.html";
    license = "GPLv3";
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
