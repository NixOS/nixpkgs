{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "MPlayer-codecs-essential-20040427";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/essential-20040427.tar.bz2;
    md5 = "4ffc1682448aa870aec9d8efc1321a09";
  };
}
