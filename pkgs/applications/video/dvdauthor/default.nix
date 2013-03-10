{ stdenv, fetchurl, imagemagick, libdvdread, libxml2, freetype, fribidi, libpng, zlib, pkgconfig }:

stdenv.mkDerivation rec{
  name = "dvdauthor-0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/dvdauthor/${name}.tar.gz";
    sha256 = "1s8zqlim0s3hk5sbdsilip3qqh0yv05l1jwx49d9rsy614dv27sh";
  };

  buildInputs = [ libpng freetype libdvdread libxml2 zlib fribidi imagemagick ];
  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = http://dvdauthor.sourceforge.net/;
    license = ["GPLv2"];
  };
}
