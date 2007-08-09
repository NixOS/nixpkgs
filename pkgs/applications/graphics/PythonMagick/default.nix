{stdenv, fetchurl, python, boost, pkgconfig, imagemagick}:

stdenv.mkDerivation {
  name = "PythonMagick-0.7";

  src = fetchurl {
    url = http://www.imagemagick.org/download/python/PythonMagick-0.7.tar.gz;
    sha256 = "1553kyzdcysii2qhbpbgs0icmfpm6s2lp3zchgs73cxfnfym8lz1";
  };

  buildInputs = [python boost pkgconfig imagemagick];

}
