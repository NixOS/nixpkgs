{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, roxctl }:

buildGoModule rec {
  pname = "roxctl";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "stackrox";
    rev = version;
    sha256 = "sha256-GrqefNH3wLMMd+JfkugVJhUHFP5vvqroAMbWLan9ylU=";
  };

  vendorHash = "sha256-y/ZoSK/lgqt8VZAb8NgCzyde/cwAhpu658/3mC/tI98=";

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
    license = licenses.asl20;
    homepage = "https://www.stackrox.io";
    maintainers = with maintainers; [ stehessel ];
  };
}
