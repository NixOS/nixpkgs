{stdenv, fetchurl}: derivation {
  name = "freetype-2.1.5";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/freetype/freetype-2.1.5.tar.bz2;
    md5 = "54537b518b84d04190a1eccd393a29df";
  };
  stdenv = stdenv;
}
