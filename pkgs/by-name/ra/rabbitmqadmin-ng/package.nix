{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rabbitmqadmin-ng";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "rabbitmqadmin-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JYKLuyBkBUrz9MtlJveBavrt6Bbew/HLstVXV70p0qg=";
  };

  cargoHash = "sha256-+CepYLzomkrFuHrffKfEH5J7JhdjAnWhFy0IVrY7VdE=";

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
