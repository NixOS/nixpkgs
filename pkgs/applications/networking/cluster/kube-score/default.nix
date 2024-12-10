{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kube-score,
}:

buildGoModule rec {
  pname = "kube-score";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3OdcYqSUy0WH5CrrRMXDs1HGxvToXx/3iPytYBdDncg=";
  };

  vendorHash = "sha256-4yd/N57O3avD8KaGU9lZAEDasPx1pRx37rqQpuGeRiY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = kube-score;
      command = "kube-score version";
    };
  };

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    mainProgram = "kube-score";
    homepage = "https://github.com/zegl/kube-score";
    changelog = "https://github.com/zegl/kube-score/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ j4m3s ];
  };
}
