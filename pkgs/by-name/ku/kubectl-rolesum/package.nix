{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rolesum";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "Ladicle";
    repo = "kubectl-rolesum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nj4LyAruyDyX9NR0bTQzuAaLPBZNLeVWilobGlHop/o=";
  };

  vendorHash = "sha256-nt/GOG4kdUrmOsMnFs6fNwiBZDVXoa7OdwnZsD2cPy8=";

  ldflags = [
    "-X github.com/Ladicle/kubectl-rolesum/cmd.version=${finalAttrs.version}"
  ];

  versionCheckProgramArg = [ "--version" ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Summarize Kubernetes RBAC roles for the specified subjects";
    mainProgram = "kubectl-rolesum";
    homepage = "https://github.com/Ladicle/kubectl-rolesum";
    changelog = "https://github.com/Ladicle/kubectl-rolesum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tboerger ];
  };
})
