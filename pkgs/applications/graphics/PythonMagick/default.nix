{stdenv, fetchurl, python, boost, pkgconfig, imagemagick}:

let

  version = "0.9.14";

in

stdenv.mkDerivation rec {
  name = "pythonmagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/python/releases/PythonMagick-${version}.tar.xz";
    sha256 = "1flkdfi3c19wy2qcfzax1cqvmmri10rvmhc2y85gmagqvv01zz22";
  };

  buildInputs = [python boost pkgconfig imagemagick];

  meta = {
    homepage = http://www.imagemagick.org/script/api.php;
  };
}
