{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-QwpChzZ+zC4MoVp6kNqbNF6+p4Rsd0KJfVuKPyxnnZU=";
  };

  cargoHash = "sha256-j/qLLyt9Sl1cXfNkKsyEYL/MQbxRMhni6uGmRVI+Xd8=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "just-lsp";
  };
})
