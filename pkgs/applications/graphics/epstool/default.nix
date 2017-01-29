{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "epstool-3.08";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/epstool-3.08.tar.gz";
    sha256 = "1pfgqbipwk36clhma2k365jkpvyy75ahswn8jczzys382jalpwgk";
  };

  patches = [ ./epstool.patch ];

  meta = {
    description = "Edit preview images and fix bounding boxes in EPS files";
    homepage = http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
