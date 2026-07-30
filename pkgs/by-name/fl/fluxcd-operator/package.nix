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
  pname = "fluxcd-operator";
  version = "0.56.0";

  src = fetchFromGitHub {
    owner = "controlplaneio-fluxcd";
    repo = "flux-operator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wx6FI4X5kBtbz1ZWeF35RSNu/FP3y4pfLnnn7ltofRQ=";
  };

  vendorHash = "sha256-sPAmFrB8Lxedsp1rmmsp2p4at0to7syxK9IR6Geh+ak=";

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/cli" ];

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/flux-operator";
  doInstallCheck = true;

  env.CGO_ENABLED = 0;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mv $out/bin/cli $out/bin/flux-operator
    for shell in bash fish zsh; do
      installShellCompletion --cmd flux-operator \
        --$shell <($out/bin/flux-operator completion $shell)
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes controller for managing the lifecycle of Flux CD";
    homepage = "https://fluxcd.control-plane.io/operator/";
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
      stealthybox
    ];
    mainProgram = "flux-operator";
  };
})
