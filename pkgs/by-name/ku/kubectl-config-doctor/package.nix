{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubectl-config-doctor";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "aptakube";
    repo = "kubectl-config-doctor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-56eqfz+9Bc+cEa4OW0U5GCdf59Rzfthmq4Zkmc7oof8=";
  };

  cargoHash = "sha256-rsQSyeb8y14dKJpXP4MT+AtdWULawwF7hyLER0zbrE8=";

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
