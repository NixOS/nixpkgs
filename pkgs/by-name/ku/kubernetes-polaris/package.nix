{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubernetes-polaris";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "polaris";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BSKJEZDXwGHIo7L8kJtf+MAMS3qLJRreCR0/WRw2egc=";
  };

  vendorHash = "sha256-t01aJVVq4CgazCEsy7nSkfUa4InTY8xrJhjxARd7o0g=";

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
