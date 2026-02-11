{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kakoune-lsp";
  version = "19.0.1";

  src = fetchFromGitHub {
    owner = "kakoune-lsp";
    repo = "kakoune-lsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MDGDc2xhQNfbczq/JT/hDd3ZPLRd9DVXdTg0VLQLNHk=";
  };

  patches = [ (replaceVars ./Hardcode-perl.patch { inherit perl; }) ];

  cargoHash = "sha256-5ESICzwLcXheqNz/E3EBX7K2RFVFPAAuoqyZsJpVijI=";

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
