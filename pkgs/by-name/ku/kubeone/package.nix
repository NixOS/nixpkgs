{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kubeone,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "kubeone";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/fOtepUysZvJQrpdNklgSeL946tSf3Icohi0bRSLieA=";
  };

  vendorHash = "sha256-4thcMvdS2oxBai+3aOUPXd5T6f2DcW0Mm1d3y/DMGFc=";

  ldflags = [
    "-s"
    "-w"
    "-X k8c.io/kubeone/pkg/cmd.version=${finalAttrs.version}"
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
    changelog = "https://github.com/kubermatic/kubeone/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lblasc ];
  };
})
