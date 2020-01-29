{ stdenv, fetchurl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "mpop";
  version = "1.4.7";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "0c6n5afn9pr4p7gxkv462lysrw52w9fhvavzm99c78dcp9dj5xnk";
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
