{ stdenv, fetchurl, pkgconfig, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "mupdf-0.7";

  src = fetchurl {
    url = "http://mupdf.com/download/archive/${name}.tar.gz";
    sha256 = "e7f6307fa472575d27fe893e787ddb3fc927f03ba4ae23105f917189e81960a6";
  };

  buildInputs = [ pkgconfig zlib freetype libjpeg jbig2dec openjpeg libX11 libXext ];

  preBuild = ''
    export makeFlags="prefix=$out"
  '';

  meta = {
    homepage = http://mupdf.com/;
    description = "Lightweight PDF viewer and toolkit written in portable C";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
