{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "nxml-mode-20040726";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.thaiopensource.com/download/nxml-mode-20040726.tar.gz;
    md5 = "d5c1d6031abfd23cd0da0b79422d9810";
  };
}
