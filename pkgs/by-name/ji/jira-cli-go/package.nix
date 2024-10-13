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
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "ankitpokhrel";
    repo = "jira-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-Wp6uDvnTiNixn8GyEn8SeKPdXanUNN3b7yr9dT1D6uo=";
  };

  vendorHash = "sha256-a11ZO/iV/Yhaq/cu504p2C/OkKJ04PeMMSoHrl7edvM=";

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
