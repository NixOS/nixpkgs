{ stdenv, fetchurl, pkgconfig, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "mupdf-1.1";

  src = fetchurl {
    url = "http://mupdf.com/download/archive/${name}-source.tar.gz";
    sha256 = "e54666bbe1d9f0a5464349bfbeffcf676c4a0fcad3efb89eba1f20d4ac991f34";
  };

  buildInputs = [ pkgconfig zlib freetype libjpeg jbig2dec openjpeg libX11 libXext ];

  preBuild = ''
    export makeFlags="prefix=$out"
    export NIX_CFLAGS_COMPILE=" $NIX_CFLAGS_COMPILE -I$(echo ${openjpeg}/include/openjpeg-*) "
  '';

  meta = {
    homepage = http://mupdf.com/;
    description = "Lightweight PDF viewer and toolkit written in portable C";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
