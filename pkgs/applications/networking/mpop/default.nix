{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.2.6";
  name = "mpop-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mpop/${name}.tar.xz";
    sha256 = "0p1ix63jh64dibrlccch8q7gxl9nn18wd2qpyr5z1h4gs2fpmv4z";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl gnutls gsasl libidn ]
    ++ optional stdenv.isDarwin Security;

  configureFlags =
    optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  meta = {
      description = "POP3 mail retrieval agent";
      homepage = http://mpop.sourceforge.net/;
      license = licenses.gpl3Plus;
      platforms = platforms.unix;
    };
}
