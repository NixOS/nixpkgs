{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kube-score,
}:

buildGoModule rec {
  pname = "kube-score";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YsbefR6WkFef5nhbD9ACQ7Xx572RsHlL2zY78RtTtsQ=";
  };

  vendorHash = "sha256-9P7emxfRolhGEMiAJmBczksWkyHVFUtPZaNrjXkZ4t4=";

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
