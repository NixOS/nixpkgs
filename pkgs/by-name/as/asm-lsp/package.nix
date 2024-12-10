{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
let
  pname = "asm-lsp";
  version = "0.6.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "asm-lsp";
    rev = "v${version}";
    hash = "sha256-vOkuTJFP2zme8S+u5j1TXt6BXnwtASRVH4Dre9g1dtk=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-lmOnBcLWfTCuQcPiRmPoFD/QvagfkApFP6/h1ot7atU=";

  # tests expect ~/.cache/asm-lsp to be writable
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Language server for NASM/GAS/GO Assembly";
    homepage = "https://github.com/bergercookie/asm-lsp";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "asm-lsp";
    platforms = lib.platforms.linux;
  };
}
