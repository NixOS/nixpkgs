{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "rabbitmqadmin-ng";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "rabbitmqadmin-ng";
    tag = "v${version}";
    hash = "sha256-edKvJKKBkZ5kkvbE4IMlo3i7uQrHlzFXzL3cn3/wa3k=";
  };

  cargoHash = "sha256-rkp/TMcEC5IDyMsCNBfUfK/H0By1DFR9aKOXAxkNHq8=";

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
