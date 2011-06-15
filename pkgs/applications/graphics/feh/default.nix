{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama, curl }:

stdenv.mkDerivation {
  name = "feh-1.14.1";

  src = fetchurl {
    url = http://www.chaosdorf.de/~derf/feh/feh-1.14.1.tar.bz2;
    sha256 = "1dask2pm7y2yjvxlwiyi0v4145alixp5lk8v68dcs0qxz8v1pqk1";
  };

  buildInputs = [x11 imlib2 giblib libjpeg libpng libXinerama curl];

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
