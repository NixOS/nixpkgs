{ stdenv, fetchurl, openssl, ncurses, pkgconfig, glib, loudmouth, libotr
, gpgme
}:

stdenv.mkDerivation rec {
  name = "mcabber-${version}";
  version = "1.0.5";

  src = fetchurl {
    url = "http://mcabber.com/files/mcabber-${version}.tar.bz2";
    sha256 = "0ixdzk5b3s31a4bdfqgqrsiq7vbgdzhqr49p9pz9cq9bgn0h1wm0";
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
