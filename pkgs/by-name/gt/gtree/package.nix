{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gtree,
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-+Prv0TtyqE02DHbYwooy8OWQn4C82Lyfikd+l0YEHZc=";
  };

  vendorHash = "sha256-0St9T9xJ8lOZgBUtwfzrHqSpcv6SAoxy4PNBBuuNO+A=";

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
    maintainers = [ ];
  };
}
