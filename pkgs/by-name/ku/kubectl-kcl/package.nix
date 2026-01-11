{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-kcl";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kubectl-kcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yuNQSO1xQCb5H55mOUTVrojeWWkDOmAGJIzUs6qCWO4=";
  };

  vendorHash = "sha256-GD4C4jlxVMpJ/bhpQ3VDkBMBBQkXyhMMga+WhVdvI/I=";

  ldflags = [
    "-X kcl-lang.io/kubectl-kcl/cmd.Version=${finalAttrs.version}"
  ];

  versionCheckProgramArg = [ "version" ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Work with Kubernetes manifests using the KCL programming language";
    mainProgram = "kubectl-kcl";
    homepage = "https://github.com/kcl-lang/kubectl-kcl";
    changelog = "https://github.com/kcl-lang/kubectl-kcl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.arichtman ];
    platforms = lib.platforms.unix;
  };
})
