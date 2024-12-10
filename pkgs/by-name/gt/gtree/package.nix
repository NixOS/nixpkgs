{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gtree,
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.10.12";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-dtKT2T8GNcR5ux1whFrXgJ08XHJWS76M/wmAtBHDLUI=";
  };

  vendorHash = "sha256-wiPHK5RjMBMLHx3Vv2zWoZc1wWJ1IVxu8dIbO9fPaPQ=";

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
