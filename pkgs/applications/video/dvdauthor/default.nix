{ stdenv, fetchurl, imagemagick, libdvdread, libxml2, freetype, fribidi, libpng, zlib }:

stdenv.mkDerivation {
  name = "dvdauthor-0.7.0";

  src = fetchurl {
    url = mirror://sourceforge/dvdauthor/dvdauthor-0.7.0.tar.gz;
    sha256 = "1l1l5zya7lirwa1783pa7h22wrfcq8hibbf5kpx8z8zbk5xsz9mf";
  };

  buildInputs = [ imagemagick libdvdread libxml2 freetype fribidi libpng zlib ];

  # Does not build against recent versions of libpng without patch.
  patches = [ ./build-against-libpng15.patch ];

  meta = { 
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = http://dvdauthor.sourceforge.net/;
    license = ["GPLv2"];
  };
}
