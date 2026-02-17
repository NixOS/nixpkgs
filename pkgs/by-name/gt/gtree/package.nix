{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gtree,
}:

buildGoModule (finalAttrs: {
  pname = "gtree";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K7LFnMCx28Abj4U9glFtQWJDHPHPRrGPsP0TiCr5NKc=";
  };

  vendorHash = "sha256-A/O8w56RsiS8VHzq4NpIn8dAt12sNpfl/Jf9KziZ12I=";

  subPackages = [
    "cmd/gtree"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.Revision=${finalAttrs.src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gtree;
    };
  };

  meta = {
    description = "Generate directory trees and directories using Markdown or programmatically";
    mainProgram = "gtree";
    homepage = "https://github.com/ddddddO/gtree";
    changelog = "https://github.com/ddddddO/gtree/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
