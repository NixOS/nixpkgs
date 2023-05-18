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
  version = "1.4.18";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-YJmVAYT30JSngtHnq5gzc28SMI00pUSlm0aoRx2fhbc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gnutls
    gsasl
    libidn
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  configureFlags = lib.optionals stdenv.isDarwin [
    "--with-macosx-keyring"
  ];

  meta = with lib;{
    description = "POP3 mail retrieval agent";
    homepage = "https://marlam.de/mpop";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
