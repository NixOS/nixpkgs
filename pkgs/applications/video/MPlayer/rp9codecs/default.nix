{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "MPlayer-rp9codecs-20050115";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/codecs/rp9codecs-20050115.tar.bz2;
    sha256 = "353c22e2c992a1c730bdd5fade66a94e1a058e38063d2ce064a6510b70c39677";
  };
}
