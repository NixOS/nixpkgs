{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:
let
  pname = "asm-lsp";
  version = "0.4.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "asm-lsp";
    rev = "v${version}";
    hash = "sha256-EGgYOU6y23ULjnMGNjYhgF0JMPgvRuQ4UOWqwJxhBpU=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-x8Cj39Wki+pdoNIO8QPGK29KFJrHtDMoZJIXFEldno0=";

  meta = {
    description = "Language server for NASM/GAS/GO Assembly";
    homepage = "https://github.com/bergercookie/asm-lsp";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "asm-lsp";
    platforms = lib.platforms.linux;
  };
}
