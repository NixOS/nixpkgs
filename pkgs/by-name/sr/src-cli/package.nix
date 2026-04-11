{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  testers,
  src-cli,
}:

buildGoModule rec {
  pname = "src-cli";
  version = "7.0.3";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-B0ESsPbB4rWRLpOnU/ugVakUaduAGCs7n+XEDIYwUxs=";
  };

  vendorHash = "sha256-WB7lXLnWsQLLfzlAyFbEbfsaTY2wbRyqsQ0PdRF1/tk=";

  subPackages = [
    "cmd/src"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sourcegraph/src-cli/internal/version.BuildTag=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = src-cli;
      command = "src version -client-only";
    };
  };

  meta = {
    description = "Sourcegraph CLI";
    homepage = "https://github.com/sourcegraph/src-cli";
    changelog = "https://github.com/sourcegraph/src-cli/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      keegancsmith
    ];
    mainProgram = "src";
  };
}
