{
  lib,
  stdenv,
  buildGoModule,
  cilium-cli,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "cilium-cli";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pW+9UN+pWkKCYRTvZxslrPgczOezVnPpDF5XdRHCh+g=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = null;

  subPackages = [ "cmd/cilium" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=${finalAttrs.version}"
  ];

  # Required to workaround install check error:
  # 2022/06/25 10:36:22 Unable to start gops: mkdir /homeless-shelter: permission denied
  HOME = "$TMPDIR";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cilium \
      --bash <($out/bin/cilium completion bash) \
      --fish <($out/bin/cilium completion fish) \
      --zsh <($out/bin/cilium completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = cilium-cli;
    command = "cilium version --client";
    version = "${finalAttrs.version}";
  };

  meta = {
    description = "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium";
    homepage = "https://www.cilium.io/";
    changelog = "https://github.com/cilium/cilium-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      humancalico
      qjoly
      ryan4yin
    ];
    mainProgram = "cilium";
  };
})
