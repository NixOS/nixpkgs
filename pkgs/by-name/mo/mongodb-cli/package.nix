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
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-cli";
    tag = "mongocli/v${version}";
    sha256 = "sha256-vhx8dxTNngDBy+34e+Er7uqIAGJImJiPmwxZX+EwIG0=";
  };

  vendorHash = "sha256-825S3jMwgZC3aInuahg6/jg4A9u/bKeie30MB9HexJY=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/mongocli" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mongocli \
      --bash <($out/bin/mongocli completion bash) \
      --fish <($out/bin/mongocli completion fish) \
      --zsh <($out/bin/mongocli completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MongoDB CLI enable you to manage your MongoDB via ops manager and cloud manager";
    homepage = "https://github.com/mongodb/mongodb-cli";
    changelog = "https://www.mongodb.com/docs/mongocli/current/release-notes/#mongodb-cli-${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.iamanaws ];
    mainProgram = "mongocli";
  };
}
