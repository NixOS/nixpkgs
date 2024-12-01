{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  harbor-cli,
  installShellFiles,
}:

buildGoModule rec {
  pname = "harbor-cli";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "goharbor";
    repo = "harbor-cli";
    rev = "v${version}";
    hash = "sha256-WSADuhr6p8N0Oh1xIG7yItM6t0EWUiAkzNbdKsSc4WA=";
  };

  vendorHash = "sha256-UUD9/5+McR1t5oO4/6TSScT7hhSKM0OpBf94LVQG1Pw=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd harbor \
      --bash <($out/bin/harbor completion bash) \
      --fish <($out/bin/harbor completion fish) \
      --zsh <($out/bin/harbor completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = harbor-cli;
    command = "harbor version";
  };

  meta = {
    homepage = "https://github.com/goharbor/harbor-cli";
    description = "Command-line tool facilitates seamless interaction with the Harbor container registry";
    changelog = "https://github.com/goharbor/harbor-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "harbor";
  };
}
