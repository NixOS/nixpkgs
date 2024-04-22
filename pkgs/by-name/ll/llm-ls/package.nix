{ lib, stdenv, darwin, rustPlatform, fetchFromGitHub }:

let
  pname = "llm-ls";
  version = "0.4.0";
in rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm-ls";
    rev = version;
    sha256 = "sha256-aMoT/rH6o4dHCSiSI/btdKysFfIbHvV7R5dRHIOF/Qs=";
  };

  cargoHash = "sha256-Z6BO4kDtlIrVdDk1fiwyelpu1rj7e4cibgFZRsl1pfA=";

  buildInputs =
    lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.cc.isClang && stdenv.isDarwin) [
    "-fno-lto" # work around https://github.com/NixOS/nixpkgs/issues/19098
  ];

  meta = with lib; {
    description = "LSP server leveraging LLMs for code completion (and more?)";
    homepage = "https://github.com/huggingface/llm-ls";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    platforms = platforms.all;
    mainProgram = "llm-ls";
  };
}
