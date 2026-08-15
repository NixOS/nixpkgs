{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-graph";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "steveteuber";
    repo = "kubectl-graph";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5N1eC8J0nHEgFUCHEn5b3kUDj6MWejouQBKkdJKsaAo=";
  };

  vendorHash = "sha256-fvn+CoOyMRjsIemMRXitMjTlbbhjrlDIHu398b4/ZZ0=";

  meta = {
    description = "Kubectl plugin to visualize Kubernetes resources and relationships";
    homepage = "https://github.com/steveteuber/kubectl-graph";
    changelog = "https://github.com/steveteuber/kubectl-graph/releases/tag/v${finalAttrs.version}";
    mainProgram = "kubectl-graph";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.rksm ];
  };
})
