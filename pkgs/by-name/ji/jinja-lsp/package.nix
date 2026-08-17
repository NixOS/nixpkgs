{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jinja-lsp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "jinja-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ve/FapX2hpyFlFFRbD4hAeQQlHaOkG2MiC9Sy68dtY8=";
  };

  cargoHash = "sha256-8sxXo2nOj30OsyrihlnpzKiS/Hz3NgpvrnctNBWzgOI=";

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
