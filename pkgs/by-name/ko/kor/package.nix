{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kor";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AvywOQnDRzus2yexr+T85i0ztDStEJgYYMI+tr+Q9ZE=";
  };

  vendorHash = "sha256-rlDaQPR9sReAX4gAlbDGAsA1ei9Fo2sXoU9cbBCexfc=";

  preCheck = ''
    HOME=$(mktemp -d)
    export HOME
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Golang Tool to discover unused Kubernetes Resources";
    homepage = "https://github.com/yonahd/kor";
    changelog = "https://github.com/yonahd/kor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
    mainProgram = "kor";
  };
}
