{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  version = "2.2.0";
  pname = "half";

  src = fetchzip {
    url = "mirror://sourceforge/half/${version}/half-${version}.zip";
    sha256 = "sha256-ZdGgBMZylFgkvs/XVBnvgBY2EYSHRLY3S4YwXjshpOY=";
    stripRoot = false;
  };

  buildCommand = ''
    mkdir -p $out/include $out/share/doc
    cp $src/include/half.hpp               $out/include/
    cp $src/{ChangeLog,LICENSE,README}.txt $out/share/doc/
  '';

  meta = {
    description = "C++ library for half precision floating point arithmetics";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
