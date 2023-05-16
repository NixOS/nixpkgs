{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, testers
, kube-score
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "kube-score";
<<<<<<< HEAD
  version = "1.17.0";
=======
  version = "1.16.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
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
=======
    hash = "sha256-/aCuPL0bzzoNczvSdLYS8obTu8bZzO5HhBmRZ3/ArAM=";
  };

  vendorHash = "sha256-pcNdszOfsYKiASOUNKflbr89j/wb9ILQvjMJYsiGPWo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    homepage = "https://github.com/zegl/kube-score";
    changelog = "https://github.com/zegl/kube-score/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ j4m3s ];
  };
}
