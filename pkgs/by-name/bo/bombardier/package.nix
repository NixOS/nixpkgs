{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  bombardier,
}:

buildGoModule rec {
  pname = "bombardier";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "codesenberg";
    repo = "bombardier";
    rev = "v${version}";
    hash = "sha256-y5UCaCJXB/RDK79QgYgR0o65RuwW2MLpynRCvqqB/i0=";
  };

  vendorHash = "sha256-SezGoDM4xzOj1y/qmvlngYKOVdJnxBD4l9LPVErevUI=";

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    version = testers.testVersion {
      package = bombardier;
    };
  };

  meta = with lib; {
    description = "Fast cross-platform HTTP benchmarking tool written in Go";
    homepage = "https://github.com/codesenberg/bombardier";
    changelog = "https://github.com/codesenberg/bombardier/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "bombardier";
  };
}
