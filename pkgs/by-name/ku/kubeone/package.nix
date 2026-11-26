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
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d4op8tBMfFdVIZ7Jcqbi+F+GgwKp4BsGO9xGzO0NDL8=";
  };

  vendorHash = "sha256-CL3/BDV1tGqQ0pW69Vlr0G1I+jpScZH4JJlCv3YrDiw=";

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
