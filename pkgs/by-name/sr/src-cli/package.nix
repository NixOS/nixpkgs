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
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-h2DIYniW0J1a8eRhKaBKfyZjOa8/EsKyqSuU0TYgxlA=";
  };

  vendorHash = "sha256-glwV5kJQ2xB1WSUZ5DEfdEWByr5BHJBLxxP8w17hReo=";

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
      burmudar
    ];
    mainProgram = "src";
  };
}
