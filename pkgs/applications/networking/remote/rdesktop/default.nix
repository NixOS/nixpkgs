{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libX11,
  krb5,
  libXcursor,
  libtasn1,
  nettle,
  gnutls,
  pkg-config,
  autoreconfHook,
  libiconv,
  enableCredssp ? (!stdenv.isDarwin),
}:

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1s6k1jwd28y38ymk3lfv76ch4arpfwrbdhpkbnwwy3fc4617gb78";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs =
    [
      openssl
      libX11
      libXcursor
      libtasn1
      nettle
      gnutls
    ]
    ++ lib.optional enableCredssp krb5
    ++ lib.optional stdenv.isDarwin libiconv;

  configureFlags = [
    "--with-ipv6"
    "--with-openssl=${openssl.dev}"
    "--disable-smartcard"
  ] ++ lib.optional (!enableCredssp) "--disable-credssp";

  meta = {
    description = "Open source client for Windows Terminal Services";
    mainProgram = "rdesktop";
    homepage = "http://www.rdesktop.org/";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl2;
  };
})
