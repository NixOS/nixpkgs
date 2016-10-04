{ stdenv, fetchurl, openssl, ncurses, pkgconfig, glib, loudmouth, libotr
, gpgme
}:

stdenv.mkDerivation rec {
  name = "mcabber-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "http://mcabber.com/files/mcabber-${version}.tar.bz2";
    sha256 = "16hkb7v1sqp1gqj94darwwrv23alqaiqdhqjq8gjd6f3l05bprj4";
  };

  buildInputs = [ openssl ncurses pkgconfig glib loudmouth libotr gpgme ];

  configureFlags = "--with-openssl=${openssl.dev} --enable-modules --enable-otr";

  doCheck = true;
  
  meta = with stdenv.lib; {
    homepage = http://mcabber.com/;
    description = "Small Jabber console client";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    updateWalker = true;
    downloadURLRegexp = "mcabber-[0-9.]+[.]tar[.][a-z0-9]+$";
  };
}
