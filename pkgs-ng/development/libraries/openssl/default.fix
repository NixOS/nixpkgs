{stdenv, fetchurl, perl}: derivation {
  name = "openssl-0.9.7c";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
      url = http://www.openssl.org/source/openssl-0.9.7c.tar.gz;
      md5 = "c54fb36218adaaaba01ef733cd88c8ec";
    };
  stdenv = stdenv;
  perl = perl;
}
