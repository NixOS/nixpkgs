{stdenv, fetchurl}: derivation {
  name = "win32codecs-1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/codecs/extralite.tar.bz2;
    md5 = "4748ecae87f71e8bda9cb2e2a9bd30b4";
  };
  stdenv = stdenv;
}
