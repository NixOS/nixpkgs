{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kor";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    rev = "v${version}";
    hash = "sha256-jqP2GsqliltjabbHDcRseMz7TOWl9YofAG/4Y7ADub8=";
  };

  vendorHash = "sha256-HZS1PPlra1uGBuerGs5X9poRzn7EGhTopKaC9tkhjlo=";

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
