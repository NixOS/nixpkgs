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
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "goharbor";
    repo = "harbor-cli";
    rev = "v${version}";
    hash = "sha256-baS4UHjmE2eURFMDBhXbx9lcKPArb2RH2NVDt3MPE4s=";
  };

  vendorHash = "sha256-rw2VPRi0VTm7/zVnQ8zL5f4mbzYKnmuxgCbgrpcukaU=";

  excludedPackages = [ "dagger" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=${version}"
  ];

  doCheck = false; # Network required

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME="$(mktemp -d)"

    installShellCompletion --cmd harbor \
      --bash <($out/bin/harbor completion bash) \
      --fish <($out/bin/harbor completion fish) \
      --zsh <($out/bin/harbor completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = harbor-cli;
    command = "HOME=\"$(mktemp -d)\" harbor version";
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
