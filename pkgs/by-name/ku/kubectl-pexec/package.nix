{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-pexec";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ssup2";
    repo = "kpexec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WW3qI9D7+DtEsRJbKptw0sbgZMLIUgJd7ar1tmvd8C8=";
  };

  vendorHash = "sha256-HmRwez3NFSF97Dc6fD/Tt78qNDjovkhlfqloYo2qG68=";

  subPackages = [ "cmd/kpexec" ];

  ldflags = [
    "-X github.com/ssup2/kpexec/pkg/cmd/kpexec.version=${finalAttrs.version}"
    "-X github.com/ssup2/kpexec/pkg/cmd/kpexec.build=kubectlPlugin"
  ];

  postInstall = ''
    mv $out/bin/kpexec $out/bin/kubectl-pexec
  '';

  versionCheckProgramArg = [ "--version" ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Execute process with privileges in a pod";
    mainProgram = "kubectl-pexec";
    homepage = "https://github.com/ssup2/kpexec";
    changelog = "https://github.com/ssup2/kpexec/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tboerger ];
  };
})
