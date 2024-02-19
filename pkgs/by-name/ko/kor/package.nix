{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kor";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GeGttcvAhCRLbScxgcV9DrNZbvlsVRyOcA4xFUlHCyI=";
  };

  vendorHash = "sha256-x3XlqyaNPafBbCOq6leUHmBzz2poxgT0mVJ8UM0aRzg=";

  preCheck = ''
    HOME=$(mktemp -d)
    export HOME
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A Golang Tool to discover unused Kubernetes Resources";
    homepage = "https://github.com/yonahd/kor";
    changelog = "https://github.com/yonahd/kor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
    mainProgram = "kor";
  };
}
