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
<<<<<<< HEAD
  version = "0.38.1";
=======
  version = "0.29.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "controlplaneio-fluxcd";
    repo = "fluxcd-operator";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-thSUS3OQecOSaC6e5o1yRuI7FAyy/wZEvp+tIdJrtSo=";
  };

  vendorHash = "sha256-Z5oKy9u/aqxoEiyDJWBBoUS5WJYWcfh77kK5wyl/pdc=";
=======
    hash = "sha256-yV8aGmY2mUAu0urIi7d1pIjhJasRX17hpmvFEQm4YpY=";
  };

  vendorHash = "sha256-zCzMNlpBBUS2P2aywFDUp/RSl+HlfQe+L8a1+vVYbgY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/mcp" ];

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/flux-operator-mcp";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  env.CGO_ENABLED = 0;

  postInstall = ''
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
