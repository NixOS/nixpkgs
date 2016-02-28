{stdenv, fetchurl, python, boost, pkgconfig, imagemagick}:

let

  version = "0.9.12";

in

stdenv.mkDerivation rec {
  name = "pythonmagick-${version}";

  src = fetchurl {
    url = "http://www.imagemagick.org/download/python/releases/PythonMagick-${version}.tar.xz";
    sha256 = "1l1kr3d7l40fkxgs6mrlxj65alv2jizm9hhgg9i9g90a8qj8642b";
  };

  buildInputs = [python boost pkgconfig imagemagick];

  meta = {
    homepage = http://www.imagemagick.org/script/api.php;
  };
}
