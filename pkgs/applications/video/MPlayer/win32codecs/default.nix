{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "MPlayer-codecs-essential-20050115";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/essential-20050115.tar.bz2;
    md5 = "b627e5710c6f2bf38fc2a6ef81c13be8";
  };
}
