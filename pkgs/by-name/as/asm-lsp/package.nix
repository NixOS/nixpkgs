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
  version = "0.10.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "asm-lsp";
    rev = "v${version}";
    hash = "sha256-RAyiE+Msmr/Qt5v7rWuUTAji383XLKxeMQJove2b1NE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-41iWqgywfFdqf3TzZT5peh39jiSZw8FRTI1AeL5CroY=";

  # tests expect ~/.cache/asm-lsp to be writable
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Language server for NASM/GAS/GO Assembly";
    homepage = "https://github.com/bergercookie/asm-lsp";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      NotAShelf
      CaiqueFigueiredo
    ];
    mainProgram = "asm-lsp";
    platforms = lib.platforms.unix;
  };
}
