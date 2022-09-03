{ lib
, stdenv
, fetchurl
, gnutls
, gsasl
, libidn
, pkg-config
, Security
}:

stdenv.mkDerivation rec {
  pname = "mpop";
  version = "1.4.17";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-Qq5JS60pQdn2R8SMPtmMOLqapc8/5I+w/gblttrfi9U=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gnutls
    gsasl
    libidn
  ] ++ lib.optional stdenv.isDarwin [
    Security
  ];

  configureFlags = lib.optional stdenv.isDarwin [
    "--with-macosx-keyring"
  ];

  meta = with lib;{
    description = "POP3 mail retrieval agent";
    homepage = "https://marlam.de/mpop";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
