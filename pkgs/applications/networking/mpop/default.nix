{ stdenv, fetchurl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "mpop";
  version = "1.4.5";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "1m6743j8g777lijvxqw2wz6pv2g5a9wlh6zq7awk0hvd44xp4sav";
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
