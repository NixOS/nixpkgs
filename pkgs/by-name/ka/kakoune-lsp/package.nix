{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kakoune-lsp";
  version = "20.0.0";

  src = fetchFromGitHub {
    owner = "kakoune-lsp";
    repo = "kakoune-lsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1O0Seyz+Wzt2aJh5Os5D/7UI4LVizvY195aXJSMpeyw=";
  };

  patches = [ (replaceVars ./Hardcode-perl.patch { inherit perl; }) ];

  cargoHash = "sha256-wmoF0pwuXN83xy4R7wC1+YBBNdseFCg8xSqkBR/Axro=";

  meta = {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kakoune-lsp/kakoune-lsp";

    # See https://github.com/kakoune-lsp/kakoune-lsp/commit/55dfc83409b9b7d3556bacda8ef8b71fc33b58cd
    license = with lib.licenses; [
      unlicense
      mit
    ];

    maintainers = with lib.maintainers; [
      philiptaron
      spacekookie
      poweredbypie
    ];

    mainProgram = "kak-lsp";
  };
})
