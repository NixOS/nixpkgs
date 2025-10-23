{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kubeone,
  testers,
}:

buildGoModule rec {
  pname = "kubeone";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${version}";
    hash = "sha256-afAyjBalBdWAnTAedAYh3GslLx//aAHQAsEbBIpiczg=";
  };

  vendorHash = "sha256-Wnnwp1GRlE1q8MSc23pOmSn9fKu5uHVzkivfuF2lnEk=";

  ldflags = [
    "-s"
    "-w"
    "-X k8c.io/kubeone/pkg/cmd.version=${version}"
    "-X k8c.io/kubeone/pkg/cmd.date=unknown"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubeone \
      --bash <($out/bin/kubeone completion bash) \
      --zsh <($out/bin/kubeone completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kubeone;
    command = "kubeone version";
  };

  meta = {
    description = "Automate cluster operations on all your cloud, on-prem, edge, and IoT environments";
    homepage = "https://kubeone.io/";
    changelog = "https://github.com/kubermatic/kubeone/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lblasc ];
  };
}
