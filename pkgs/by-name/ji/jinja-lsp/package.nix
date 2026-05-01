{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jinja-lsp";
  version = "0.1.91";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "jinja-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BOZIbuEZQAEVtB/rfZVPuUki4hdbq0+NEsXr26+zZ3o=";
  };

  cargoHash = "sha256-1tXgHd4PBOxa4YzHClahrrkRsbwBoT5lMdigB5CE5Zw=";

  cargoBuildFlags = [
    "-p"
    "jinja-lsp"
  ];

  meta = {
    description = "Language server implementation for jinja2";
    homepage = "https://github.com/uros-5/jinja-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamjhf ];
    mainProgram = "jinja-lsp";
  };
})
