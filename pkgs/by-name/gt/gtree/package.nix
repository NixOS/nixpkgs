{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gtree,
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.10.14";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-c9ocRHvcu8rSgJ0Hc7E9ObsMHZtN/qvif4APUzqpjro=";
  };

  vendorHash = "sha256-jZlR29OUefVKx3vxigvHbsIWsZbMPNAIPEa+qoU2oo0=";

  subPackages = [
    "cmd/gtree"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Revision=${src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gtree;
    };
  };

  meta = with lib; {
    description = "Generate directory trees and directories using Markdown or programmatically";
    mainProgram = "gtree";
    homepage = "https://github.com/ddddddO/gtree";
    changelog = "https://github.com/ddddddO/gtree/releases/tag/${src.rev}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
  };
}
