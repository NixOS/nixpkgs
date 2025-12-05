{
  lib,
  fetchFromGitHub,
  crystal,
  openssl,
  testers,
  amqpcat,
}:

crystal.buildCrystalPackage rec {
  pname = "amqpcat";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "cloudamqp";
    repo = "amqpcat";
    tag = "v${version}";
    hash = "sha256-fdDdMjeAlJ0H05LNVdRxwq6RK41d6rXLFQMw6RSlXZM=";
  };

  format = "shards";
  shardsFile = ./shards.nix;

  buildInputs = [ openssl ];

  # Tests require network access
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = amqpcat;
  };

  meta = {
    description = "CLI tool for publishing to and consuming from AMQP servers";
    mainProgram = "amqpcat";
    homepage = "https://github.com/cloudamqp/amqpcat";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
