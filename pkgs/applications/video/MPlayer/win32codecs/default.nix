{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "MPlayer-codecs-essential-20060611";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www4.mplayerhq.hu/MPlayer/releases/codecs/essential-20060611.tar.bz2;
    md5 = "26ec3f9feed5f89814b2ec5f436e937b";
  };
}
