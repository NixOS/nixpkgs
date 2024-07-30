{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:
let
  pname = "asm-lsp";
  version = "0.7.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "asm-lsp";
    rev = "v${version}";
    hash = "sha256-LWsawBh1czS7LUX70IXrJHUonIt2XEN8L26iP5cVyRk=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-pIjOelOQ5X8jl/ZtE8IzXPtcLmANDtWsJaNXno8CT6Y=";

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
