{ stdenv, fetchurl, openssl, ncurses, pkgconfig, glib, loudmouth, libotr
, gpgme
}:

stdenv.mkDerivation rec {
  name = "mcabber-${version}";
  version = "0.10.3";

  src = fetchurl {
    url = "http://mcabber.com/files/mcabber-${version}.tar.bz2";
    sha256 = "0vgsqw6yn0lzzcnr4fql4ycgf3gwqj6w4p0l4nqnvhkc94w62ikp";
  };

  buildInputs = [ openssl ncurses pkgconfig glib loudmouth libotr gpgme ];

  configureFlags = "--with-openssl=${openssl} --enable-modules --enable-otr";
  
  meta = with stdenv.lib; {
    homepage = http://mcabber.com/;
    description = "Small Jabber console client";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
