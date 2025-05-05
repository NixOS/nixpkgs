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
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "radsecproxy";
    repo = "radsecproxy";
    tag = version;
    hash = "sha256-E7nU6NgCmwRzX5j1Zyx/LTztjLqYJKv+3VU6UE0HhZA=";
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
