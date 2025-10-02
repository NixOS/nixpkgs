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
    repo = "kube-score";
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

  meta = {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    mainProgram = "kube-score";
    homepage = "https://github.com/zegl/kube-score";
    changelog = "https://github.com/zegl/kube-score/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j4m3s ];
  };
}
