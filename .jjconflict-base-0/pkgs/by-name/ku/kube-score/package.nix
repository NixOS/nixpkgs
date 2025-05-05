{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kube-score,
}:

buildGoModule rec {
  pname = "kube-score";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZqhuqPWCfJKi38Jdazr5t5Wulsqzl1D4/81ZTvW10Co=";
  };

  vendorHash = "sha256-uv+82x94fEa/3tjcofLGIPhJpwUzSkEbarGVq8wVEUc=";

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
