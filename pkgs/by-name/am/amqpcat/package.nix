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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "cloudamqp";
    repo = "amqpcat";
    tag = "v${version}";
    hash = "sha256-qy70OLVMfjBpww3rPvwWrAULVCreP6jhUqyKG3utsy0=";
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
