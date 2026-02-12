{
  lib,
  stdenv,
  fetchurl,
  gnutls,
  openssl,
  gsasl,
  libidn,
  pkg-config,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "mpop";
  version = "1.4.21";

  src = fetchurl {
    url = "https://marlam.de/mpop/releases/mpop-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-TKDR4NATZv4+DPSQ2I0VTfURJ4+1lWOHE748pnVmWFU=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    lib.optional gsaslSupport gsasl
    ++ lib.optional idnSupport libidn
    ++ lib.optional (sslLibrary == "gnutls") gnutls
    ++ lib.optional (sslLibrary == "openssl") openssl;

  configureFlags = [
    (lib.enableFeature nlsSupport "nls")
    (lib.withFeature idnSupport "idn")
    (lib.withFeature gsaslSupport "gsasl")
    "--with-tls=${sslLibrary}"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "--with-macosx-keyring";

  meta = {
    description = "POP3 mail retrieval agent";
    homepage = "https://marlam.de/mpop";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
