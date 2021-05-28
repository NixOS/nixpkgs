{ stdenv, fetchurl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "mpop";
  version = "1.4.10";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "1243hazpiwgvz2m3p48cdh0yw1019i6xjxgc7qyhmxcdy0inb6wy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnutls gsasl libidn ]
    ++ optional stdenv.isDarwin Security;

  configureFlags = optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  meta = {
      description = "POP3 mail retrieval agent";
      homepage = "https://marlam.de/mpop";
      license = licenses.gpl3Plus;
      platforms = platforms.unix;
    };
}
