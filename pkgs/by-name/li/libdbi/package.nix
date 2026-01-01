{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libdbi";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/libdbi/${pname}-${version}.tar.gz";
    sha256 = "00s5ra7hdlq25iv23nwf4h1v3kmbiyzx0v9bhggjiii4lpf6ryys";
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://libdbi.sourceforge.net/";
    description = "DB independent interface to DB";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://libdbi.sourceforge.net/";
    description = "DB independent interface to DB";
    license = licenses.lgpl21;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
