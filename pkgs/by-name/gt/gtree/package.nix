{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gtree,
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.11.8";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-IBsfE0Y/LzXIaQdbXv1ZOslwj2U5fAhYIo67BixwDMY=";
  };

  vendorHash = "sha256-jGFEKwe0eglsj3U2jdlfMKYsMvwSu/z0EX+heCKQP0c=";

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
