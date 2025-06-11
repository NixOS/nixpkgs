{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  testers,
  mongodb-atlas-cli,
}:

buildGoModule rec {
  pname = "mongodb-atlas-cli";
  version = "1.43.2";

  vendorHash = "sha256-Pem+3HH/bdf1SulsLo/5hsFYN8p7kQve0vXptUFnvsM=";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-atlas-cli";
    rev = "refs/tags/atlascli/v${version}";
    sha256 = "sha256-Xb/6kgqee38DqbLPLkel8NhXxdjq4UYX4E/y3xUW7og=";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mongodb/mongodb-atlas-cli/atlascli/internal/version.GitCommit=${src.rev}"
    "-X github.com/mongodb/mongodb-atlas-cli/atlascli/internal/version.Version=v${version}"
  ];

  postInstall = ''
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
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "CLI utility to manage MongoDB Atlas from the terminal";
    maintainers = with lib.maintainers; [ aduh95 ];
    license = lib.licenses.asl20;
    mainProgram = "atlas";
  };
}
