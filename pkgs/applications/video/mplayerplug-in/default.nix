{stdenv, fetchurl, x11}:

assert x11 != null;

stdenv.mkDerivation {
  name = "mplayerplug-in-1.0pre2";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/mplayerplug-in/mplayerplug-in-1.0pre2.tar.gz;
    md5 = "1a6eb243989c143984bb1aac63b5282e";
  };

  x11 = x11;
}
