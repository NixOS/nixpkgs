{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "kakoune-lsp";
<<<<<<< HEAD
  version = "19.0.1";
=======
  version = "18.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kakoune-lsp";
    repo = "kakoune-lsp";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MDGDc2xhQNfbczq/JT/hDd3ZPLRd9DVXdTg0VLQLNHk=";
=======
    hash = "sha256-71XnCHAXOcrXu0xizwdwJPkhnmfEjmVP++6mxmTcnM4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [ (replaceVars ./Hardcode-perl.patch { inherit perl; }) ];

<<<<<<< HEAD
  cargoHash = "sha256-5ESICzwLcXheqNz/E3EBX7K2RFVFPAAuoqyZsJpVijI=";
=======
  cargoHash = "sha256-cr/fvV2JjjfLdsT0Ej2aNoNKDLqmJsOOREcwxWpjfE0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
}
