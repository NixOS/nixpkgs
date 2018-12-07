{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.4.0";
  name = "mpop-${version}";

  src = fetchurl {
    url = "https://marlam.de/mpop/releases/${name}.tar.xz";
    sha256 = "14xsvpm5bc1wycisq882gqrnamnyi1q4rlk6anlw8ihzvwgm4h2j";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl gnutls gsasl libidn ]
    ++ optional stdenv.isDarwin Security;

  configureFlags = [ "--with-tls=openssl" ] ++
    optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  meta = {
      description = "POP3 mail retrieval agent";
      homepage = https://marlam.de/mpop;
      license = licenses.gpl3Plus;
      platforms = platforms.unix;
    };
}
