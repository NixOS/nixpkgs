{ stdenv, fetchurl, pkgconfig, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "mupdf-0.6";

  src = fetchurl {
    url = "http://mupdf.com/download/source/${name}.tar.gz";
    sha256 = "01cn2kz4zx53qhqvbxy8xd7xqbh58kpid8ykvx5hz7pf2gqw91vg";
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
