{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubectl-config-doctor";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "aptakube";
    repo = "kubectl-config-doctor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I4BRpNzQI7WM4JWhPZlGpMLR6XyIYNNdZXt0UMAO0oo=";
  };

  cargoHash = "sha256-A7MNMX8cpBxgT2rKHs4ySzkpQTn96nX3f+wkEAg2P/E=";

  doCheck = false; # Package has no tests

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubectl plugin to validate and test kubeconfigs";
    homepage = "https://github.com/aptakube/kubectl-config-doctor";
    changelog = "https://github.com/aptakube/kubectl-config-doctor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "kubectl-config-doctor";
  };
})
