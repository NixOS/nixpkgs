{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gtree,
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-a2kQVn/3PyGZliPOB/2hFULK+YJBv7JVv0p7cbmfsN0=";
  };

  vendorHash = "sha256-ARmyA8qYKv8xTmpaN77D/NlBfFJFVTGudpBeQG5apso=";

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
