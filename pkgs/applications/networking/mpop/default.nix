{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.4.3";
  name = "mpop-${version}";

  src = fetchurl {
    url = "https://marlam.de/mpop/releases/${name}.tar.xz";
    sha256 = "1di86frxv4gj8fasni409m87qmv0j0vmj13lawkz1pwv9hbynhjb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnutls gsasl libidn ]
    ++ optional stdenv.isDarwin Security;

  configureFlags = optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  meta = {
      description = "POP3 mail retrieval agent";
      homepage = https://marlam.de/mpop;
      license = licenses.gpl3Plus;
      platforms = platforms.unix;
    };
}
