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
  version = "1.44.0";

  vendorHash = "sha256-FSf+JbIbM7EumkVmQ/ASRCIu7X6tyerhRx01/Rn0+LM=";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-atlas-cli";
    rev = "refs/tags/atlascli/v${version}";
    sha256 = "sha256-1XSIXLI0ItQPOcFXhswnnrKN5LqWRs/th4EdfvdS/G8=";
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
