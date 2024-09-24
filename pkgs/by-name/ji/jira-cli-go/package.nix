{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  jira-cli-go,
  less,
  more,
  nix-update-script,
  testers,
}:

buildGoModule rec {
  pname = "jira-cli-go";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ankitpokhrel";
    repo = "jira-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-edytj9hB8lDwy3qGSyLudu5G4DSRGKhD0vDoWz5eUgs=";
  };

  vendorHash = "sha256-DAdzbANqr0fa4uO8k/yJFoirgbZiKOQhOH8u8d+ncao=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.GitCommit=${src.rev}"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.SourceDateEpoch=0"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd jira \
      --bash <($out/bin/jira completion bash) \
      --fish <($out/bin/jira completion fish) \
      --zsh <($out/bin/jira completion zsh)

    $out/bin/jira man --generate --output man
    installManPage man/*
  '';

  nativeCheckInputs = [
    less
    more
  ]; # Tests expect a pager in $PATH

  passthru = {
    tests.version = testers.testVersion {
      package = jira-cli-go;
      command = "jira version";
      inherit version;
    };
    updateScript = nix-update-script { };
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Feature-rich interactive Jira command line";
    homepage = "https://github.com/ankitpokhrel/jira-cli";
    changelog = "https://github.com/ankitpokhrel/jira-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      bryanasdev000
      anthonyroussel
    ];
    mainProgram = "jira";
  };
}
