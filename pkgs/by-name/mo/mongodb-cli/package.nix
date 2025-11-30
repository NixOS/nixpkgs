{
  stdenv,
  fetchFromGitHub,
  lib,
  buildGoModule,
  installShellFiles,
  nix-update-script,
}:

buildGoModule rec {
  pname = "mongodb-cli";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-cli";
    tag = "mongocli/v${version}";
    hash = "sha256-ltNYphGNUyg12Xjg3kmmMVdSYyzMUjdVeXjDi6O4T08=";
  };

  vendorHash = "sha256-X5qIte7TFn9b54cg0NF4yrFuAjqTdLXPx0qPGK54jnY=";

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
    changelog = "https://www.mongodb.com/docs/mongocli/current/release-notes/#mongodb-cli-${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.iamanaws ];
    mainProgram = "mongocli";
  };
}
