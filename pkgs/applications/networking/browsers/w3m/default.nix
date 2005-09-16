{ stdenv, fetchurl, ncurses
, sslSupport ? true, openssl ? null, boehmgc, gettext
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "w3m-0.5.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/w3m/w3m-0.5.1.tar.gz;
    md5 = "0678b72e07e69c41709d71ef0fe5da13";
  };
  inherit openssl boehmgc;
  buildInputs = [ncurses (if sslSupport then openssl else null) boehmgc gettext];
}
