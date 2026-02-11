{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rabbitmqadmin-ng";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "rabbitmqadmin-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5esZgvaIaAkEDaeBzda3I1LfYS4ho3Nb6ypqank6+U=";
  };

  cargoHash = "sha256-Aj6DVn9vPG0U0iMlUVAaxpsyaLyHMj/TeH4sftvuTi8=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  strictDeps = true;

  # This requires a running rabbitmq instance to communicate with that needs
  # to be set up by hand. It should be possible to run tests in the future
  # if we ever add a `rabbitmqTestHook`, similar to the `postgresqlTestHook`.
  doCheck = false;

  meta = {
    description = "Command line tool for RabbitMQ that uses the HTTP API";
    homepage = "https://www.rabbitmq.com/docs/management-cli";
    maintainers = [
      lib.maintainers.leona
      lib.maintainers.osnyx
    ];
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "rabbitmqadmin";
  };
})
