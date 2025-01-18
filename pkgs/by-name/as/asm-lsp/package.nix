{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
let
  pname = "asm-lsp";
  version = "0.9.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "asm-lsp";
    rev = "v${version}";
    hash = "sha256-0GB3tXZuCu3syh+RG+eXoliZVHMPOhYC3RchSSx4u5w=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  cargoHash = "sha256-AtCnYOOtViMpg+rz8miuBZg1pENBPaf9kamSPaVUyiw=";

  # tests expect ~/.cache/asm-lsp to be writable
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Language server for NASM/GAS/GO Assembly";
    homepage = "https://github.com/bergercookie/asm-lsp";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      NotAShelf
      CaiqueFigueiredo
    ];
    mainProgram = "asm-lsp";
    platforms = platforms.unix;
  };
}
