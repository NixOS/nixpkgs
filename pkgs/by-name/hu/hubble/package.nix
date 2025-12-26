{
  stdenv,
  lib,
  buildGo124Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGo124Module rec {
  pname = "hubble";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "hubble";
    tag = "v${version}";
    hash = "sha256-9TY7at4k3IrxJJ4HmAW9oeQX3Wg0V/LGVDNGYfBOvSA=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/cilium/cilium/hubble/pkg.GitBranch=none"
    "-X=github.com/cilium/cilium/hubble/pkg.GitHash=none"
    "-X=github.com/cilium/cilium/hubble/pkg.Version=${version}"
  ];

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hubble \
      --bash <($out/bin/hubble completion bash) \
      --fish <($out/bin/hubble completion fish) \
      --zsh <($out/bin/hubble completion zsh)
  '';

  meta = {
    description = "Network, Service & Security Observability for Kubernetes using eBPF";
    homepage = "https://github.com/cilium/hubble/";
    changelog = "https://github.com/cilium/hubble/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      humancalico
      FKouhai
    ];
    mainProgram = "hubble";
  };
}
