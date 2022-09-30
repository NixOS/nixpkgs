{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, kubeone
, testers
}:

buildGoModule rec {
  pname = "kubeone";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${version}";
    sha256 = "sha256-DGLbbIDX2JASre/AQ1eWStNeu4GHgRTQyzrJRTz5DyE=";
  };

  vendorSha256 = "sha256-w/uLR7wi28Ub7Nouxxg39NlD1OzyIE2oEP4D88Xbwu0=";

  ldflags = [
    "-s -w"
    "-X k8c.io/kubeone/pkg/cmd.version=${version}"
    "-X k8c.io/kubeone/pkg/cmd.date=unknown"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd kubeone \
      --bash <($out/bin/kubeone completion bash) \
      --zsh <($out/bin/kubeone completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kubeone;
    command = "kubeone version";
  };

  meta = {
    description = "Automate cluster operations on all your cloud, on-prem, edge, and IoT environments.";
    homepage = "https://kubeone.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lblasc ];
  };
}
