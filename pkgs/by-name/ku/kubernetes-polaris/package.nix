{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubernetes-polaris";
  version = "10.1.6";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "polaris";
    rev = finalAttrs.version;
    sha256 = "sha256-lIvOWX3j4N0vG9jXFxKyKqdMERNov6NI/RaNPBN3MVM=";
  };

  vendorHash = "sha256-pfO5+iDUZY8PIOw/47qcopfox4DX2yf/4fqiLM94AF8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=${finalAttrs.version}"
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
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ longer ];
  };
})
