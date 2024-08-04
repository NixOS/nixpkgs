{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

let
  pname = "llm-ls";
  version = "0.5.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm-ls";
    rev = version;
    sha256 = "sha256-ICMM2kqrHFlKt2/jmE4gum1Eb32afTJkT3IRoqcjJJ8=";
  };

  cargoHash = "sha256-Fat67JxTYIkxkdwGNAyTfnuLt8ofUGVJ2609sbn1frU=";

  buildAndTestSubdir = "crates/llm-ls";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

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
