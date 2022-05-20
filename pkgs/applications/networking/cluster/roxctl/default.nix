{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testVersion, roxctl }:

buildGoModule rec {
  pname = "roxctl";
  version = "3.69.1";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "stackrox";
    rev = version;
    sha256 = "sha256-fB43C+gMtUOg/Ah1fOTnOWOUmS0TjXkNCzw/TKfMzj4=";
  };

  vendorSha256 = "sha256-M+ZueycJEaDVzC2bFwQc5EulCrdz6lvzyD8YCoGyW1g=";

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

  passthru.tests.version = testVersion {
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
