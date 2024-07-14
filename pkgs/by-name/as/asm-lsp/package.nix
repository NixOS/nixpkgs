{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:
let
  pname = "asm-lsp";
  version = "0.7.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "asm-lsp";
    rev = "v${version}";
    hash = "sha256-nHLM4cwVo6esrrpr4s+DfJIUWWKSrYwWLOPC84tb68o=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-CiHXfy8Xqrg8SAWA4nTHSGZKS0pGcoQem9kLRtTLpRs=";

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
