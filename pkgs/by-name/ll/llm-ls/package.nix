{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

let
  pname = "llm-ls";
  version = "0.5.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm-ls";
    rev = version;
    sha256 = "sha256-DyPdx+nNBhOZ86GQljMYULatWny2EteNNzzO6qv1Wlk=";
  };

  cargoHash = "sha256-7McUyQjnCuV0JG65hUoR8TtB4vrjiEO1l7NXYochgG8=";

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
