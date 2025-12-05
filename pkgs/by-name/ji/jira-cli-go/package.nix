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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ankitpokhrel";
    repo = "jira-cli";
    tag = "v${version}";
    hash = "sha256-NJXLB2N8Kc8Ow6kb2EtPSG+iZ7O4yrhAMi3NFrUuocA=";
  };

  vendorHash = "sha256-cl+Sfi9WSPy8qOtB13rRiKtQdDC+HC0+FMKpsWbtU2w=";

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

  meta = {
    description = "Feature-rich interactive Jira command line";
    homepage = "https://github.com/ankitpokhrel/jira-cli";
    changelog = "https://github.com/ankitpokhrel/jira-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anthonyroussel
    ];
    mainProgram = "jira";
  };
}
