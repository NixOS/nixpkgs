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
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-AJe/Xmc5HQ47voMBVjGLuxuugm5Y+yWDP9NwlzMg51s=";
  };

  vendorHash = "sha256-cr5KUYuEDlahkz2DwTD2yw+Tl/QrTP2O6b1HzQqXnzE=";

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
