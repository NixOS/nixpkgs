{ lib
, buildGoModule
, fetchFromGitHub
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

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    homepage = "https://github.com/zegl/kube-score";
    changelog = "https://github.com/zegl/kube-score/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ j4m3s ];
  };
}
