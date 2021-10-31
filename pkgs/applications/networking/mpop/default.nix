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
  version = "1.4.16";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-hw61cerm0j+5KtDITXnenDjF9iTjYUk31XS/5Jumh/k=";
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
