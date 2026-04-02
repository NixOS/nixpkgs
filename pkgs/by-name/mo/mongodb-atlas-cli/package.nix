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

buildGoModule (finalAttrs: {
  pname = "mongodb-atlas-cli";
  version = "1.53.2";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-atlas-cli";
    tag = "atlascli/v${finalAttrs.version}";
    hash = "sha256-njclhtUYLya51mZSb4VKdR0CslaVGpFbYPw4v9qMEjo=";
  };

  vendorHash = "sha256-5P5wiWY4KnSR2T67BT/9d1xKPZdCZ7SE6oYjWmMcN/Q=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mongodb/mongodb-atlas-cli/atlascli/internal/version.GitCommit=${finalAttrs.src.rev}"
    "-X github.com/mongodb/mongodb-atlas-cli/atlascli/internal/version.Version=v${finalAttrs.version}"
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
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "CLI utility to manage MongoDB Atlas from the terminal";
    homepage = "https://github.com/mongodb/mongodb-atlas-cli";
    changelog = "https://www.mongodb.com/docs/atlas/cli/current/atlas-cli-changelog/#atlas-cli-${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aduh95
      iamanaws
    ];
    mainProgram = "atlas";
  };
})
