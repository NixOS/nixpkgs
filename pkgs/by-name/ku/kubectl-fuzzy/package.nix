{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kubectl-fuzzy,
  testers,
}:

buildGoModule rec {
  pname = "kubectl-fuzzy";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "d-kuro";
    repo = "kubectl-fuzzy";
    rev = "v${version}";
    hash = "sha256-sqFP0PDu4nFn9hONpqvyc2I5BtpsDuJfkVdz4Ae43fw=";
  };

  vendorHash = "sha256-0cXT0x19s57q1ocLJvE0zlw4ce+hdW+KXwTTXQvD72c=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/kubectl-fuzzy" ];

  passthru.tests.version = testers.testVersion {
    package = kubectl-fuzzy;
    command = "kubectl-fuzzy version || true"; # mask non-zero return code if no kubeconfig present
    version = "v${version}";
  };

  meta = {
    description = "Use fzf-like fuzzy finder to search Kubernetes resources.";
    mainProgram = "kubectl-fuzzy";
    homepage = "https://github.com/d-kuro/kubectl-fuzzy";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.DrRuhe ];
  };
}
