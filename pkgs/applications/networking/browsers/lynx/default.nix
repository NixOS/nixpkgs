{ stdenv, fetchurl, ncurses
, sslSupport ? true, openssl ? null
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "lynx-2.8.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://lynx.isc.org/release/lynx2.8.5.tar.bz2;
    md5 = "d1e5134e5d175f913c16cb6768bc30eb";
  };
  inherit ncurses;
  configureFlags = (if sslSupport then "--with-ssl" else "");
  buildInputs = [ncurses (if sslSupport then openssl else null)];
}
