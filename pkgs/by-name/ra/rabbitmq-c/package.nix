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
  version = "0.15.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uOI+YV9aV/LGlSxr75sSii5jQ005smCVe14QAGNpKY8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "RabbitMQ C AMQP client library";
    homepage = "https://github.com/alanxz/rabbitmq-c";
    license = licenses.mit;
    platforms = platforms.unix;
    pkgConfigModules = [ "librabbitmq" ];
  };

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };
})
