{stdenv, fetchurl, openssl, ncurses, pkgconfig, glib, loudmouth}:

stdenv.mkDerivation {

  name = "mcabber-0.10.1";

  src = fetchurl {
    url = "http://mcabber.com/files/mcabber-0.10.1.tar.bz2";
    sha256 = "1248cgci1v2ypb90wfhyipwdyp1wskn3gzh78af5ai1a4w5rrjq0";
  };

  meta = { homepage = "http://mcabber.com/";
           description = "Small Jabber console client";
         };

  buildInputs = [openssl ncurses pkgconfig glib loudmouth];

  configureFlags = "--with-openssl=${openssl}";
}
