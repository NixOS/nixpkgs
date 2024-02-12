{ lib
, buildGoModule
, fetchFromGitHub
, testers
, kube-score
}:

buildGoModule rec {
  pname = "kube-score";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/4xnUb60ARGO6hM5PQ3ZkuwjEQUT4Xnj/InIsfw2bzI=";
  };

  vendorHash = "sha256-UpuwkQHcNg3rohr+AdALakIdHroIySlTnXHgoUdY+EQ=";

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
    homepage = "https://github.com/zegl/kube-score";
    changelog = "https://github.com/zegl/kube-score/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ j4m3s ];
  };
}
