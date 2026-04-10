{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-evict-pod";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "rajatjindal";
    repo = "kubectl-evict-pod";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-s4u9g24xBhJsymjY+AEtzybY88Q7Ajj7xgIAD2OZt9U=";
  };

  vendorHash = "sha256-1D+AnC5h/9wJc4I0+0bitOS1kCDiIb0L4xvnOo/T2os=";

  meta = {
    description = "This plugin evicts the given pod and is useful for testing pod disruption budget rules";
    mainProgram = "kubectl-evict-pod";
    homepage = "https://github.com/rajatjindal/kubectl-evict-pod";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.j4m3s ];
  };
})
