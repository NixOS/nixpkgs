{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "code-generator";
  version = "0.25.4";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GKF6DXvyZujInOZbV0ePUu71BEl1s/chNTN1PucdIYw=";
  };

  vendorHash = "sha256-zjgTtGen6a8TPi/DrwheTS1VQ+hd+KI7UHoyMZ4W4+k=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/kubernetes/code-generator";
    changelog = "https://github.com/kubernetes/code-generator/releases/tag/v${version}";
    description = "Kubernetes code generation";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
