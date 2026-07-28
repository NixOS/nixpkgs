{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  autoreconfHook,
  nettle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "radsecproxy";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "radsecproxy";
    repo = "radsecproxy";
    tag = finalAttrs.version;
    hash = "sha256-QSRK7uljYn2kqGypfkZBWhVPGk/x1y6WT9FT5pqwWS0=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    openssl
    nettle
  ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = {
    homepage = "https://radsecproxy.github.io/";
    description = "Generic RADIUS proxy that supports both UDP and TLS (RadSec) RADIUS transports";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
})
