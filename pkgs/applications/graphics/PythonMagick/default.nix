{stdenv, fetchurl, python, boost, pkgconfig, imagemagick}:

let

  version = "0.9.11";

in

stdenv.mkDerivation rec {
  name = "pythonmagick-${version}";

  src = fetchurl {
    url = "http://www.imagemagick.org/download/python/releases/PythonMagick-${version}.tar.gz";
    sha256 = "01z01mlqkk0lvrh2jsmf84qjw29sq4rpj0653x7nqy7mrszwwp2v";
  };

  buildInputs = [python boost pkgconfig imagemagick];

  meta = {
    homepage = http://www.imagemagick.org/script/api.php;
  };
}
