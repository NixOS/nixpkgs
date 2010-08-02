{ stdenv, fetchurl, imagemagick, libdvdread, libxml2, freetype, fribidi, libpng }:

stdenv.mkDerivation {
  name = "dvdauthor-0.6.14";

  src = fetchurl {
    url = mirror://sourceforge/dvdauthor/dvdauthor-0.6.14.tar.gz;
    sha256 = "1x4flj3ja7m8rbc956a6ha3qk0k6zxd1y6sl826r6r7dyc91a6yx";
  };

  buildInputs = [ imagemagick libdvdread libxml2 freetype fribidi libpng ];

  meta = { 
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = http://dvdauthor.sourceforge.net/;
    license = ["GPLv2"];
  };
}
