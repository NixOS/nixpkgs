{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "rabbitmqadmin-ng";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "rabbitmqadmin-ng";
    tag = "v${version}";
    hash = "sha256-OaSCqK3VwR5b6tQUfGFM/clHynwG0TgMy2ZEcFsLFx0=";
  };

  cargoHash = "sha256-dynUbe6UCVdPEpy+fXABhzSsrF/OV5z1eMvrXtzKs70=";

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
