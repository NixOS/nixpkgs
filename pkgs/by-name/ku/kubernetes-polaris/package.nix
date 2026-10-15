{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo127Module (finalAttrs: {
  pname = "kubernetes-polaris";
  version = "10.2.5";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "polaris";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SY7w7ltpoQNEA76ONqSSsDmkcK5s82NIpB/g3DQoCqs=";
  };

  vendorHash = "sha256-MRNqMINPdc1ifhl6fiLb6sO34m50/QsBrCEjy8CiMdA=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=${finalAttrs.version}"
  ];

  # These tests don't work in the build sandbox.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-skip=^TestConfig(FromURL|NoServerError)$"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd polaris \
      --bash <($out/bin/polaris completion bash) \
      --fish <($out/bin/polaris completion fish) \
      --zsh <($out/bin/polaris completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/polaris help
    $out/bin/polaris version | grep 'Polaris version:${finalAttrs.version}'

    runHook postInstallCheck
  '';

  meta = {
    description = "Validate and remediate Kubernetes resources to ensure configuration best practices are followed";
    mainProgram = "polaris";
    homepage = "https://www.fairwinds.com/polaris";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ longer ];
  };
})
