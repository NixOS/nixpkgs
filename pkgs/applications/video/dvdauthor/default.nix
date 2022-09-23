{ lib
, stdenv
, fetchurl
, imagemagick
, libdvdread
, libxml2
, freetype
, fribidi
, libpng
, zlib
, pkg-config
, flex
, bison
}:

stdenv.mkDerivation rec {
  pname = "dvdauthor";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/dvdauthor/dvdauthor-${version}.tar.gz";
    sha256 = "1s8zqlim0s3hk5sbdsilip3qqh0yv05l1jwx49d9rsy614dv27sh";
  };

  buildInputs = [ libpng freetype libdvdread libxml2 zlib fribidi imagemagick flex bison ];
  nativeBuildInputs = [ pkg-config ];

  patches = [
    ./dvdauthor-0.7.1-automake-1.13.patch
    ./dvdauthor-0.7.1-mga-strndup.patch
    ./dvdauthor-imagemagick-0.7.0.patch
  ];

  meta = with lib; {
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = "http://dvdauthor.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
