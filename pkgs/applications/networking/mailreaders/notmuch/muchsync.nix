{ stdenv, fetchurl
, notmuch, openssl, pkgconfig, sqlite, xapian
}:
stdenv.mkDerivation rec {
  version = "2";
  name = "muchsync-${version}";
  src = fetchurl {
    url = "http://www.muchsync.org/src/${name}.tar.gz";
    sha256 = "1dqp23a043kkzl0g2f4j3m7r7lg303gz7a0fsj0dm5ag3kpvp5f1";
  };
  buildInputs = [ notmuch openssl pkgconfig sqlite xapian ];
}
