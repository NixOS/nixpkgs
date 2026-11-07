{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rabbitmq-c";
  version = "0.18.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C0urh28g7RpAkjP5u9kRpCFR7iVozv9TydewyXTR+Y4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  meta = {
    description = "RabbitMQ C AMQP client library";
    homepage = "https://github.com/alanxz/rabbitmq-c";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "librabbitmq" ];
  };

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };
})
