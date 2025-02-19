{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  notation,
}:

buildGoModule rec {
  pname = "notation";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "notaryproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gLhvXDD6hFnQw7Q9wq/9S4heB921Hjj+rPI7yhsg9SE=";
  };

  vendorHash = "sha256-CqvRTHnEZTaSSHx3g6yx1yMdI3YbdWsGo9hsnXdIuUs=";

  nativeBuildInputs = [
    installShellFiles
  ];

  # This is a Go sub-module and cannot be built directly (e2e tests).
  excludedPackages = [ "./test" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/notaryproject/notation/internal/version.Version=${version}"
    "-X github.com/notaryproject/notation/internal/version.BuildMetadata="
  ];

  postInstall = ''
    installShellCompletion --cmd notation \
      --bash <($out/bin/notation completion bash) \
      --fish <($out/bin/notation completion fish) \
      --zsh <($out/bin/notation completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = notation;
    command = "notation version";
  };

  meta = {
    description = "CLI tool to sign and verify OCI artifacts and container images";
    homepage = "https://notaryproject.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "notation";
  };
}
