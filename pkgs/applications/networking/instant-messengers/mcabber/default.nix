{ stdenv, fetchurl, openssl, ncurses, pkgconfig, glib, loudmouth, libotr
, gpgme
}:

stdenv.mkDerivation rec {
  name = "mcabber-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "http://mcabber.com/files/mcabber-${version}.tar.bz2";
    sha256 = "14rd17rs26knmwinfv63w2xzlkj5ygvhicx95h0mai4lpji4b6jp";
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
