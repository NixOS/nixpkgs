{ lib
, rustPlatform
, fetchFromGitHub
}:

let
  pname = "llm-ls";
  version = "0.4.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm-ls";
    rev = version;
    sha256 = "sha256-aMoT/rH6o4dHCSiSI/btdKysFfIbHvV7R5dRHIOF/Qs=";
  };

  cargoHash = "sha256-Z6BO4kDtlIrVdDk1fiwyelpu1rj7e4cibgFZRsl1pfA=";

  meta = with lib; {
    description = "LSP server leveraging LLMs for code completion (and more?)";
    homepage = "https://github.com/huggingface/llm-ls";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
    mainProgram = "llm-ls";
  };
}
