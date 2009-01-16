{stdenv, fetchurl, openssl, ncurses, pkgconfig, glib}:

stdenv.mkDerivation {

  name = "mcabber-0.9.9";

  src = fetchurl {
    url = http://mirror.mcabber.com/files/mcabber-0.9.9.tar.bz2;
    sha256 = "2a231c9241211d33745f110f35cfa6bdb051b32791461b9579794b6623863bb1";
  };

  meta = { homepage = "http://mirror.mcabber.com/";
           description = "Small Jabber console client";
         };

  buildInputs = [openssl ncurses pkgconfig glib];

  configureFlags = "--with-openssl=${openssl}";
}
