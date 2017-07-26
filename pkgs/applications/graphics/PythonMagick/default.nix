# This expression provides Python bindings to ImageMagick. Python libraries are supposed to be called via `python-packages.nix`.

{stdenv, fetchurl, python, boost, pkgconfig, imagemagick}:

stdenv.mkDerivation rec {
  name = "pythonmagick-${version}";
  version = "0.9.16";

  src = fetchurl {
    url = "mirror://imagemagick/python/releases/PythonMagick-${version}.tar.xz";
    sha256 = "0vkgpmrdz530nyvmjahpdrvcj7fd7hvsp15d485hq6103qycisv8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [python boost imagemagick];

  meta = {
    homepage = http://www.imagemagick.org/script/api.php;
  };
}
