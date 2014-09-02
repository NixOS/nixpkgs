{stdenv, fetchurl, openssl, ncurses, pkgconfig, glib, loudmouth}:

stdenv.mkDerivation rec {
  name = "mcabber-${version}";
  version = "0.10.3";

  src = fetchurl {
    url = "http://mcabber.com/files/mcabber-${version}.tar.bz2";
    sha256 = "1248cgci1v2ypb90wfhyipwdyp1wskn3gzh78af5ai1a4w5rrjq0";
  };

  buildInputs = [openssl ncurses pkgconfig glib loudmouth];

  configureFlags = "--with-openssl=${openssl}";
  
  meta = with stdenv.lib; {
    homepage = http://mcabber.com/;
    description = "Small Jabber console client";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
