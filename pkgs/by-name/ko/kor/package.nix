{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kor";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SMy7oAOKSvUrqIh11kdsREySsxJHmwSUhpW++DB0M2Y=";
  };

  vendorHash = "sha256-OAPilV4/usbejE/e6vVjvyuIIHCRiomPeg8RfzAmwWc=";

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
