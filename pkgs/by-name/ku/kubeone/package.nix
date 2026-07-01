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
  version = "1.13.5";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uh724TvrxAGt6NpArot5PL49yyJF+EUeh2JVoMfR+uw=";
  };

  vendorHash = "sha256-kJ4ypt0jNWA/BFiuur/pa/qd87csSdRMcV/IplQRA3I=";

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
