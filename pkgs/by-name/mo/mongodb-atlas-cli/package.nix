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
  version = "1.46.2";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-atlas-cli";
    tag = "refs/tags/atlascli/v${version}";
    hash = "sha256-yg6GSG4TXPj4n8s4TK/i7NveJXMAQczONSrLn39PKVI=";
  };

  vendorHash = "sha256-z42tJJD/iK9GDnYxdeMYogaMviGABizxX9fdWL8vVik=";

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
