{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama, curl }:

stdenv.mkDerivation {
  name = "feh-2.0";

  src = fetchurl {
    url = http://feh.finalrewind.org/feh-2.0.tar.bz2;
    sha256 = "0ilrabi0i4gads6b5r4d7svdav00n5vxjcn6h4kbd05d2hz0mjf5";
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
