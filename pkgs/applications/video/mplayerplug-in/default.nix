{stdenv, fetchurl, x11}:

assert x11 != null;

derivation {
  name = "mplayerplug-in-1.0pre2";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/mplayerplug-in/mplayerplug-in-1.0pre2.tar.gz;
    md5 = "1a6eb243989c143984bb1aac63b5282e";
  };

  stdenv = stdenv;
  x11 = x11;
}
