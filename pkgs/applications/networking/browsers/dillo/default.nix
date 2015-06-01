{ stdenv, fetchurl
, fltk
, openssl
, libjpeg, libpng
, perl
, libXcursor, libXi, libXinerama }:

stdenv.mkDerivation rec {
  version = "3.0.4.1";
  name = "dillo-${version}";

  src = fetchurl {
    url = "http://www.dillo.org/download/${name}.tar.bz2";
    sha256 = "0iw617nnrz3541jkw5blfdlk4x8jxb382pshi8nfc7xd560c95zd";
  };

  buildInputs = with stdenv.lib;
    [ fltk openssl libjpeg libpng libXcursor libXi libXinerama ];

  nativeBuildInputs = [ perl ];

  configureFlags =  "--enable-ssl";

  meta = with stdenv.lib; {
    homepage = http://www.dillo.org/;
    description = "A fast graphical web browser with a small footprint";
    longDescription = ''
      Dillo is a small, fast web browser, tailored for older machines.
    '';
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
