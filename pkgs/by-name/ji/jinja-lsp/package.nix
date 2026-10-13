{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jinja-lsp";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "jinja-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fjn4iJH3/Cgo+mD/tnJL12i+teVLNqb2xryZfhrZckg=";
  };

  cargoHash = "sha256-8fKuqidgvtHanFgxyETbs7SrFVO9tmf0IogSq5URdF0=";

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
