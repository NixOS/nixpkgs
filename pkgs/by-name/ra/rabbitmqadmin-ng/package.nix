{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "rabbitmqadmin-ng";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "rabbitmqadmin-ng";
    tag = "v${version}";
    hash = "sha256-zbxe+pu5db0D32UpPF4Np0rtha1lmavwafcvyWBli9k=";
  };

  cargoHash = "sha256-Qzj9hhVNnlrRA355nYRep2YEUD/CXqXo2XTOXGE/bEo=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  strictDeps = true;

  # This requires a running rabbitmq instance to communicate with that needs
  # to be set up by hand. It should be possible to run tests in the future
  # if we ever add a `rabbitmqTestHook`, similar to the `postgresqlTestHook`.
  doCheck = false;

  meta = {
    description = "Command line tool for RabbitMQ that uses the HTTP API";
    teams = [ lib.teams.flyingcircus ];
    homepage = "https://www.rabbitmq.com/docs/management-cli";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "rabbitmqadmin";
  };
}
