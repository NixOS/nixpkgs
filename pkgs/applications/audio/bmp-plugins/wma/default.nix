{stdenv, fetchurl, pkgconfig, bmp}:

stdenv.mkDerivation {
  name = "bmp-plugin-wma-1.0.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://mcmcc.bat.ru/xmms-wma/xmms-wma-1.0.5.tar.bz2;
    md5 = "5d62a0f969617aeb40096362c7a8a506";
  };
  buildInputs = [pkgconfig bmp];
}
