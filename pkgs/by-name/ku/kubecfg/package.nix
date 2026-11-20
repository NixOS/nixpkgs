{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubecfg";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-or7xRjyo0mjgnJnDZPD2YklGo32rWYg7iaPtUzj2ijw=";
  };

  vendorHash = "sha256-FMC3d2RmFlXMWiohVk7j/6S0HmrM7/smPDjOmBDAjQE=";

  # Separate Go module used only to host-test the wasm build.
  excludedPackages = [ "./wasm/hosttest" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubecfg \
      --bash <($out/bin/kubecfg completion --shell=bash) \
      --zsh  <($out/bin/kubecfg completion --shell=zsh)
  '';

  meta = {
    description = "Tool for managing Kubernetes resources as code";
    mainProgram = "kubecfg";
    homepage = "https://github.com/kubecfg/kubecfg";
    changelog = "https://github.com/kubecfg/kubecfg/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      qjoly
    ];
  };
})
