{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubernetes-metrics-server";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "metrics-server";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1yzX1GkuCA321Z+v4XQqzO6Leuy5DhUUU0l8wlYJ16Y=";
  };

  vendorHash = "sha256-r1E2ZxLLVcZEZd8iih3SJhkjfUeN48NWuZbxgwxCpYE=";

  preCheck = ''
    # the e2e test breaks the sandbox, so let's skip that
    rm test/e2e_test.go
  '';

  meta = {
    homepage = "https://github.com/kubernetes-sigs/metrics-server";
    description = "Kubernetes container resource metrics collector";
    mainProgram = "metrics-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eskytthe ];
  };
})
