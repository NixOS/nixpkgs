{stdenv, fetchurl, pcre}: derivation {
  name = "gnugrep-2.5.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/grep/grep-2.5.1.tar.bz2;
    md5 = "ddd99e2d5d4f4611357e31e97f080cf2";
  };
  stdenv = stdenv;
  pcre = pcre;
}
