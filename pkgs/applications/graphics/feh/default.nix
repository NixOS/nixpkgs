{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama, curl }:

stdenv.mkDerivation rec {
  name = "feh-2.8";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "0zmslchnzvi9ydxj2mgci4x8zpv5mdfkf7kyny3nibbpajibqmrx";
  };

  buildInputs = [x11 imlib2 giblib libjpeg libpng libXinerama curl ];

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
