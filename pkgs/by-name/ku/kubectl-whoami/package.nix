{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-whoami";
  version = "0.0.46";

  src = fetchFromGitHub {
    owner = "rajatjindal";
    repo = "kubectl-whoami";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Az8H0JL1DkFDj1qhm5lo8Vy5GyP6ubObBqZWHpNm+UQ=";
  };

  vendorHash = "sha256-RyeTTtJpnrpIhcfJrrmDP9TiTrwiTHlh4xjskaxG1Go=";

  ldflags = [
    "-X github.com/rajatjindal/kubectl-whoami/pkg/cmd.Version=${finalAttrs.version}"
  ];

  versionCheckProgramArg = [ "--version" ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Get the subject name using the effective kubeconfig";
    mainProgram = "kubectl-whoami";
    homepage = "https://github.com/rajatjindal/kubectl-whoami";
    changelog = "https://github.com/rajatjindal/kubectl-whoami/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tboerger ];
  };
})
