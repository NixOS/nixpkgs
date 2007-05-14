{ stdenv, fetchurl, ncurses
, sslSupport ? true, openssl ? null
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "lynx-2.8.6";
  src = fetchurl {
    url = http://lynx.isc.org/lynx2.8.6/lynx2.8.6.tar.bz2;
    sha256 = "0kbnxg01w1hczii6yqkx05dcx6yfcpqadrsavjyq3h68birc366w";
  };
  configureFlags = (if sslSupport then "--with-ssl" else "");
  buildInputs = [ncurses (if sslSupport then openssl else null)];

  meta = {
    description = "A text-mode web browser";
  };
}
