{
  stdenv,
  fetchFromGitHub,
  lib,
  buildGoModule,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mongodb-cli";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-cli";
    tag = "mongocli/v${finalAttrs.version}";
    hash = "sha256-vytc/e+e6JE5bwh5hny9C7LWenGctQLUso8GAXgk4j8=";
  };

  vendorHash = "sha256-CswQV9uTnL58TzYaVzx6dc1aZDZQ5b2LWLE1bv+P/2c=";

  subPackages = [ "cmd/mongocli" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mongocli \
      --bash <($out/bin/mongocli completion bash) \
      --fish <($out/bin/mongocli completion fish) \
      --zsh <($out/bin/mongocli completion zsh)
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=mongocli/v(.+)" ]; };

  meta = {
    description = "Manage your MongoDB via ops manager and cloud manager";
    homepage = "https://github.com/mongodb/mongodb-cli";
    changelog = "https://www.mongodb.com/docs/mongocli/current/release-notes/#mongodb-cli-${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.iamanaws ];
    mainProgram = "mongocli";
  };
})
