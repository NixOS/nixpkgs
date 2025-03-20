{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  autoreconfHook,
  nettle,
}:

stdenv.mkDerivation rec {
  pname = "radsecproxy";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "radsecproxy";
    repo = "radsecproxy";
    tag = version;
    hash = "sha256-2+NDcz2RGRa30+XXS/PT5rjjKJYEnibYY3mVWjDv7Jk=";
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
    maintainers = with lib.maintainers; [ sargon ];
    platforms = with lib.platforms; linux;
  };
}
