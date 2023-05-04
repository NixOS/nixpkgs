{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubernetes-metrics-server";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "metrics-server";
    rev = "v${version}";
    sha256 = "sha256-hPI+Wq0mZ2iu4FSDpdPdGEqgFCeUdqeK5ldJCByDE4M=";
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
