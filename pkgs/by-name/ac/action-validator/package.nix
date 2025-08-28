{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "action-validator";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "mpalmer";
    repo = "action-validator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqWowcc/3NHtVcNDZ+4opgtwttcKdUVoi4qkv56JvY4=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-w6qC4gJ06TfoQl2WD8lgOxSxUWyG6Z8ma9mUvvYlkTU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to validate GitHub Action and Workflow YAML files";
    homepage = "https://github.com/mpalmer/action-validator";
    license = lib.licenses.gpl3Plus;
    mainProgram = "action-validator";
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
})
