{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, roxctl }:

buildGoModule rec {
  pname = "roxctl";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "stackrox";
    rev = version;
    sha256 = "sha256-zTZ03Qtb3ndBf1MunhYS8rzPReExzEPGxCh1JexkwuA=";
  };

  vendorHash = "sha256-Sl5eIK8PWeGi2V7q/Qm5Gfjj1A9nQPtM0BGdO6inPxk=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "roxctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stackrox/rox/pkg/version/internal.MainVersion=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd roxctl \
      --bash <($out/bin/roxctl completion bash) \
      --fish <($out/bin/roxctl completion fish) \
      --zsh <($out/bin/roxctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = roxctl;
    command = "roxctl version";
  };

  meta = with lib; {
    description = "Command-line client of the StackRox Kubernetes Security Platform";
    mainProgram = "roxctl";
    license = licenses.asl20;
    homepage = "https://www.stackrox.io";
    maintainers = with maintainers; [ stehessel ];
  };
}
