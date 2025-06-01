{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "fluxcd-operator-mcp";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "controlplaneio-fluxcd";
    repo = "fluxcd-operator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SszWTuK3HVsyc669NThQn5VAVwD/7JQtKtqBJD6cTT0=";
  };

  vendorHash = "sha256-5uT/pcfXrinyJ1hXmQ+vmWNuyO33c6d5PAjm6kwOZmY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/mcp" ];

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/flux-operator-mcp";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  env.CGO_ENABLED = 0;

  postInstall =
    ''
      mv $out/bin/mcp $out/bin/flux-operator-mcp
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash fish zsh; do
        installShellCompletion --cmd flux-operator-mcp \
          --$shell <($out/bin/flux-operator-mcp completion $shell)
      done
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes controller for managing the lifecycle of Flux CD";
    homepage = "https://fluxcd.control-plane.io/mcp/";
    downloadPage = "https://github.com/controlplaneio-fluxcd/flux-operator";
    longDescription = ''
      The Flux Operator is a Kubernetes CRD controller that manages the lifecycle of CNCF Flux CD
      and the ControlPlane enterprise distribution. The operator extends Flux with self-service
      capabilities and preview environments for GitLab and GitHub pull requests testing.
    '';
    changelog = "https://github.com/controlplaneio-fluxcd/flux-operator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      mattfield
    ];
    mainProgram = "flux-operator-mcp";
  };
})
