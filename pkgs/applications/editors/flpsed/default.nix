{stdenv, fetchurl, fltk13, ghostscript}:

stdenv.mkDerivation {
  name = "flpsed-0.7.2";

  src = fetchurl {
    url = "http://www.ecademix.com/JohannesHofmann/flpsed-0.7.2.tar.gz";
    sha256 = "1132nlganr6x4f4lzcp9l0xihg2ky1l7xk8vq7r2l2qxs97vbif8";
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
