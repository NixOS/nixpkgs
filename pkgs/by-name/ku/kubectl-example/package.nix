{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-example";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "seredot";
    repo = "kubectl-example";
    rev = "v${version}";
    hash = "sha256-YvB4l+7GLSyYWX2Fbk4gT2WLaQpNxeV0aHY3Pg+9LCM=";
  };

  vendorHash = null;

  meta = {
    description = "kubectl plugin for retrieving resource example YAMLs";
    mainProgram = "kubectl-example";
    homepage = "https://github.com/seredot/kubectl-example";
    changelog = "https://github.com/seredot/kubectl-example/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bryanasdev000 ];
  };
}
