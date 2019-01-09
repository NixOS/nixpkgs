{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn, Security }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.4.1";
  name = "mpop-${version}";

  src = fetchurl {
    url = "https://marlam.de/mpop/releases/${name}.tar.xz";
    sha256 = "1b9mj6yfa8vg5flxw1xb8xalifjg87dghbg523i6fbr7679zl9iy";
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
