{ stdenv, fetchurl, openssl, ncurses, pkgconfig, glib, loudmouth, libotr
, gpgme
}:

stdenv.mkDerivation rec {
  name = "mcabber-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "http://mcabber.com/files/mcabber-${version}.tar.bz2";
    sha256 = "0ckh2l5fbnykzbvdrqjwd1ppalaifb79nnizh8kra2sy76xbqxjl";
  };

  buildInputs = [ openssl ncurses pkgconfig glib loudmouth libotr gpgme ];

  configureFlags = "--with-openssl=${openssl} --enable-modules --enable-otr";

  doCheck = true;
  
  meta = with stdenv.lib; {
    homepage = http://mcabber.com/;
    description = "Small Jabber console client";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
