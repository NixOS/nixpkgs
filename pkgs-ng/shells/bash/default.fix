{stdenv, fetchurl}: derivation {
  name = "bash-2.05b";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/bash/bash-2.05b.tar.gz;
    md5 = "5238251b4926d778dfe162f6ce729733";
  };
  stdenv = stdenv;
}
