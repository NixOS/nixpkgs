# This expression provides Python bindings to ImageMagick. Python libraries are supposed to be called via `python-packages.nix`.

{stdenv, fetchurl, python, boost, pkgconfig, imagemagick}:

stdenv.mkDerivation rec {
  name = "pythonmagick-${version}";
  version = "0.9.16";

  src = fetchurl {
    url = "mirror://imagemagick/python/releases/PythonMagick-${version}.tar.xz";
    sha256 = "137278mfb5079lns2mmw73x8dhpzgwha53dyl00mmhj2z25varpn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [python boost imagemagick];

  meta = {
    homepage = http://www.imagemagick.org/script/api.php;
  };
}
