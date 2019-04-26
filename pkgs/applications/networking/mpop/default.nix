{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "mpop";
  version = "1.4.4";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "0j21cp8bw12vgfymxi3i4av3j97lrcyb5y9xa3mb59wr17izz73x";
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
