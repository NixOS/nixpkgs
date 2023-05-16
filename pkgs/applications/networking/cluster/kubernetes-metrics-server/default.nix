{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubernetes-metrics-server";
<<<<<<< HEAD
  version = "0.6.4";
=======
  version = "0.6.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "metrics-server";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-e9iFOe2iZaKbYNUk0vuyzcGDCNxot34kRH06L5UQs4I=";
=======
    sha256 = "sha256-hPI+Wq0mZ2iu4FSDpdPdGEqgFCeUdqeK5ldJCByDE4M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-BR9mBBH5QE3FMTNtyHfHA1ei18CIDr5Yhvg28hGbDR4=";

  preCheck = ''
    # the e2e test breaks the sandbox, so let's skip that
    rm test/e2e_test.go
  '';

  meta = with lib; {
    homepage = "https://github.com/kubernetes-sigs/metrics-server";
    description = "Kubernetes container resource metrics collector";
    license = licenses.asl20;
    maintainers = with maintainers; [ eskytthe ];
  };
}
