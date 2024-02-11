{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, roxctl }:

buildGoModule rec {
  pname = "roxctl";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "stackrox";
    rev = version;
    sha256 = "sha256-5UMU3oKi3QhREum2YevOzwF5OOi8quPWgt+kgGjkeFQ=";
  };

  vendorHash = "sha256-Jzv4ozR8RJiwkgVGGq6dlV/7rbBLq8hFe/Pm4SJZCkU=";

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
