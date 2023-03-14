{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubernetes-metrics-server";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "metrics-server";
    rev = "v${version}";
    sha256 = "sha256-TTI+dNBQ/jKt6Yhud3/OO+zOkeO46CmUz6J6ByX26JE=";
  };

  vendorSha256 = "sha256-lpSMvHYlPtlJQUqsdXJ6ewBEBiwLPvP/rsUgYzJhOxc=";

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
