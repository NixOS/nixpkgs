{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "MPlayer-codecs-essential-20050115";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www1.mplayerhq.hu/MPlayer/releases/codecs/essential-20050115.tar.bz2;
    md5 = "b627e5710c6f2bf38fc2a6ef81c13be8";
  };
}
