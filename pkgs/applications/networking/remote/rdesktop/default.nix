{stdenv, fetchFromGitHub, openssl, libX11, krb5, libXcursor, libtasn1, nettle, gnutls, pkgconfig, autoreconfHook
, enableCredssp ? (!stdenv.isDarwin)
} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1s6k1jwd28y38ymk3lfv76ch4arpfwrbdhpkbnwwy3fc4617gb78";
  };

  nativeBuildInputs = [pkgconfig autoreconfHook];
  buildInputs = [openssl libX11 libXcursor libtasn1 nettle gnutls]
    ++ stdenv.lib.optional enableCredssp krb5;

  configureFlags = [
    "--with-ipv6"
    "--with-openssl=${openssl.dev}"
    "--disable-smartcard"
  ] ++ stdenv.lib.optional (!enableCredssp) "--disable-credssp";

  meta = {
    description = "Open source client for Windows Terminal Services";
    homepage = "http://www.rdesktop.org/";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.gpl2;
  };
})
