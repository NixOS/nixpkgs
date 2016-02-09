{stdenv, fetchurl, fltk13, ghostscript}:

stdenv.mkDerivation {
  name = "flpsed-0.7.3";

  src = fetchurl {
    url = "http://www.ecademix.com/JohannesHofmann/flpsed-0.7.3.tar.gz";
    sha256 = "0vngqxanykicabhfdznisv82k5ypkxwg0s93ms9ribvhpm8vf2xp";
  };

  buildInputs = [ fltk13 ghostscript ];

  meta = {
    description = "WYSIWYG PostScript annotator";
    homepage = "http://http://flpsed.org/flpsed.html";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
