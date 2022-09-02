{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubeone";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${version}";
    sha256 = "sha256-GC51gKAwurrsm8/zkYpSs7bnT55kpctsTpN6ZtlYxHk=";
  };

  vendorSha256 = "sha256-w/uLR7wi28Ub7Nouxxg39NlD1OzyIE2oEP4D88Xbwu0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd kubeone \
      --bash <($out/bin/kubeone completion bash) \
      --zsh <($out/bin/kubeone completion zsh)
  '';

  meta = {
    description = "Automate cluster operations on all your cloud, on-prem, edge, and IoT environments.";
    homepage = "https://kubeone.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lblasc ];
  };
}
