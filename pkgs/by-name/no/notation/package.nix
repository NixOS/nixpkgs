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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "notaryproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TliXrI5G+1Zw5vhrpEtcjDv2EjRjUsGEfwKOOf8vtZg=";
  };

  vendorHash = "sha256-kK4iwpzSz0JFnY1DbA7rjIzrqZO3imTCOfgtQKd0oV8=";

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

  meta = with lib; {
    description = "CLI tool to sign and verify OCI artifacts and container images";
    homepage = "https://notaryproject.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "notation";
  };
}
