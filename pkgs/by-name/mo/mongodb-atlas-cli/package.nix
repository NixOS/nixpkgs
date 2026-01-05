{
  stdenv,
  fetchFromGitHub,
  lib,
  buildGoModule,
  installShellFiles,
  nix-update-script,
  testers,
  mongodb-atlas-cli,
}:

buildGoModule rec {
  pname = "mongodb-atlas-cli";
  version = "1.50.1";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-atlas-cli";
    tag = "atlascli/v${version}";
    hash = "sha256-hDiHECN58mwTufU9nsbKtBlUiweTuOfMgsADcguCKzA=";
  };

  vendorHash = "sha256-StKuOuyVPJ+fSWcRKR53yyr9cB8GD3dfzyex3sMzsAk=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mongodb/mongodb-atlas-cli/atlascli/internal/version.GitCommit=${src.rev}"
    "-X github.com/mongodb/mongodb-atlas-cli/atlascli/internal/version.Version=v${version}"
  ];

  subPackages = [ "cmd/atlas" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=atlascli/v(.+)" ];
    };
    tests.version = testers.testVersion {
      package = mongodb-atlas-cli;
      version = "v${version}";
    };
  };

  meta = {
    description = "CLI utility to manage MongoDB Atlas from the terminal";
    homepage = "https://github.com/mongodb/mongodb-atlas-cli";
    changelog = "https://www.mongodb.com/docs/atlas/cli/current/atlas-cli-changelog/#atlas-cli-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aduh95
      iamanaws
    ];
    mainProgram = "atlas";
  };
}
