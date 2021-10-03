{ lib, stdenv, fetchurl, pkg-config, gnutls, gsasl, libidn, Security }:

with lib;

stdenv.mkDerivation rec {
  pname = "mpop";
  version = "1.4.14";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "046wbglvry54id9wik6c020fs09piv3gig3z0nh5nmyhsxjw4i18";
  };

  nativeBuildInputs = [ pkg-config ];
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
