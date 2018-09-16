{ stdenv, fetchurl, openssl, ncurses, pkgconfig, glib, loudmouth, libotr
, gpgme
}:

stdenv.mkDerivation rec {
  name = "mcabber-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://mcabber.com/files/mcabber-${version}.tar.bz2";
    sha256 = "1ggh865p1rf10ffsnf4g6qv9i8bls36dxdb1nzs5r9vdqci2rz04";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ncurses glib loudmouth libotr gpgme ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--enable-modules"
    "--enable-otr"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://mcabber.com/;
    description = "Small Jabber console client";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    updateWalker = true;
    downloadPage = "http://mcabber.com/files/";
    downloadURLRegexp = "mcabber-[0-9.]+[.]tar[.][a-z0-9]+$";
  };
}
