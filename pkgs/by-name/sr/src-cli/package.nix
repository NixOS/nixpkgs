{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  testers,
  src-cli,
}:

buildGoModule (finalAttrs: {
  pname = "src-cli";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = finalAttrs.version;
    hash = "sha256-22UlYQxxtInPYgj4rsu07MvusjoW4BoqCW6fbgwQ9Lc=";
  };

  vendorHash = "sha256-+phJFHid2ytXeLrvGMGTXplDAcN9YEDhRrO9ax/d8R8=";

  subPackages = [
    "cmd/src"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sourcegraph/src-cli/internal/version.BuildTag=${finalAttrs.version}"
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
    changelog = "https://github.com/sourcegraph/src-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      keegancsmith
      burmudar
    ];
    mainProgram = "src";
  };
})
