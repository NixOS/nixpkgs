{ stdenv, fetchurl, fltk, openssl, libpng, libjpeg }:
stdenv.mkDerivation rec {
  name = "htmldoc-1.8.27";
  src = fetchurl {
    url = http://ftp.easysw.com/pub/htmldoc/1.8.27/htmldoc-1.8.27-source.tar.bz2;
    sha256 = "04wnxgx6fxdxwiy9vbawdibngwf55mi01hjrr5fkfs22fcix5zw9";
  };
  buildInputs = [ fltk openssl libpng libjpeg ];
  meta = {
    homepage = http://www.htmldoc.org/;
    description = "Converts HTML files to indexed HTML, PS or PDF";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
