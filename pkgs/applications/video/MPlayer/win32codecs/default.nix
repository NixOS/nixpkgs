{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "MPlayer-codecs-essential-20050412";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/codecs/essential-20050412.tar.bz2;
    md5 = "5fe89bb095bdf9b4f9cda5479dbde906";
  };
}
