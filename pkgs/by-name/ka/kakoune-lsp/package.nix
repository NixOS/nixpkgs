{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kakoune-lsp";
  version = "22.0.0";

  src = fetchFromGitHub {
    owner = "kakoune-lsp";
    repo = "kakoune-lsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-G4L9FOS097U7pLpYTnsUF0FK7UjQ9oQRTtH0ifsL5Ks=";
  };

  patches = [ (replaceVars ./Hardcode-perl.patch { inherit perl; }) ];

  cargoHash = "sha256-QL2uE0hZtrZFJm3KpnTDXACjPY4gNefP76QjD0ZOLMo=";

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
