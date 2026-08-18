{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-example";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "seredot";
    repo = "kubectl-example";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YvB4l+7GLSyYWX2Fbk4gT2WLaQpNxeV0aHY3Pg+9LCM=";
  };

  vendorHash = null;

  meta = {
    description = "kubectl plugin for retrieving resource example YAMLs";
    mainProgram = "kubectl-example";
    homepage = "https://github.com/seredot/kubectl-example";
    changelog = "https://github.com/seredot/kubectl-example/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
