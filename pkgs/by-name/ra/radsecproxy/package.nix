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
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-4w5aQIh3loHrxFGhWt6pW2jgj/JuqQSYmNsnAkEuKoI=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    openssl
    nettle
  ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
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
