# This expression provides Python bindings to ImageMagick. Python libraries are supposed to be called via `python-packages.nix`.

{ stdenv, fetchurl, python, pkgconfig, imagemagick, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "pythonmagick-${version}";
  version = "0.9.16";

  src = fetchurl {
    url = "mirror://imagemagick/python/releases/PythonMagick-${version}.tar.xz";
    sha256 = "137278mfb5079lns2mmw73x8dhpzgwha53dyl00mmhj2z25varpn";
  };

  postPatch = ''
    rm configure
  '';

  configureFlags = [ "--with-boost=${python.pkgs.boost}" ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ python python.pkgs.boost imagemagick ];

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org/script/api.php;
    license = licenses.imagemagick;
    description = "PythonMagick provides object oriented bindings for the ImageMagick Library.";
  };
}
