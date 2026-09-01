{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gopatch,
}:

buildGoModule (finalAttrs: {
  pname = "gopatch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "gopatch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zP5zC71icrVvzKzBBlxfX9h5JlKd89cf32Q6eZatX44=";
  };

  vendorHash = "sha256-ZHXzaR8pd6kApY3PBl9GV1iRc2jdDHMfewDn1j9npjc=";

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main._version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gopatch;
    };
  };

  meta = {
    description = "Refactoring and code transformation tool for Go";
    mainProgram = "gopatch";
    homepage = "https://github.com/uber-go/gopatch";
    changelog = "https://github.com/uber-go/gopatch/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
