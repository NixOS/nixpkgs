{stdenv, fetchurl, zlib, libjpeg}:

assert !isNull zlib && !isNull libjpeg;

derivation {
  name = "libtiff-3.5.7";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.remotesensing.org/pub/libtiff/tiff-v3.5.7.tar.gz;
    md5 = "82243b5ae9b7c9e492aeebc501680990";
  };
  stdenv = stdenv;
  zlib = zlib;
  libjpeg = libjpeg;
}
