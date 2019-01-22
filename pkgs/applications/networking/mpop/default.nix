{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "mpop-${version}";

  src = fetchurl {
    url = "https://marlam.de/mpop/releases/${name}.tar.xz";
    sha256 = "1rx5mhgqkm7swbynrhbsz32v85h0rydb4kqfgfs9jrznd9d14m2d";
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
