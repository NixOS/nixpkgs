{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  bombardier,
}:

buildGoModule rec {
  pname = "bombardier";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "codesenberg";
    repo = "bombardier";
    rev = "v${version}";
    hash = "sha256-FoaiUky0WcipkGN8KIpSd+iizinlqtHC5lskvNCnx/Y=";
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

  meta = {
    description = "Fast cross-platform HTTP benchmarking tool written in Go";
    homepage = "https://github.com/codesenberg/bombardier";
    changelog = "https://github.com/codesenberg/bombardier/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "bombardier";
  };
}
