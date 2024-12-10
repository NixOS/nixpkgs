{
  lib,
  stdenv,
  fetchurl,
  gnutls,
  openssl,
  gsasl,
  libidn,
  pkg-config,
  Security,
  nlsSupport ? true,
  idnSupport ? true,
  gsaslSupport ? true,
  sslLibrary ? "gnutls",
}:
assert lib.assertOneOf "sslLibrary" sslLibrary [
  "gnutls"
  "openssl"
  "no"
];

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

  buildInputs =
    lib.optional stdenv.isDarwin Security
    ++ lib.optional gsaslSupport gsasl
    ++ lib.optional idnSupport libidn
    ++ lib.optional (sslLibrary == "gnutls") gnutls
    ++ lib.optional (sslLibrary == "openssl") openssl;

  configureFlags = [
    (lib.enableFeature nlsSupport "nls")
    (lib.withFeature idnSupport "idn")
    (lib.withFeature gsaslSupport "gsasl")
    "--with-tls=${sslLibrary}"
  ] ++ lib.optional stdenv.isDarwin "--with-macosx-keyring";

  meta = with lib; {
    description = "POP3 mail retrieval agent";
    homepage = "https://marlam.de/mpop";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
