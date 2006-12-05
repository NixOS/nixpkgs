{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "MPlayer-codecs-essential-20061022";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www1.mplayerhq.hu/MPlayer/releases/codecs/essential-20061022.tar.bz2;
    md5 = "abcf4a3abc16cf88c9df7e0a77e9b941";
  };
}
