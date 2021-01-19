{ lib, stdenv, fetchurl, pkg-config, gnutls, gsasl, libidn, Security }:

with lib;

stdenv.mkDerivation rec {
  pname = "mpop";
  version = "1.4.11";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "1gcxvhin5y0q47svqbf90r5aip0cgywm8sq6m84ygda7km8xylwv";
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
