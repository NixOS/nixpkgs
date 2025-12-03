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
  version = "0.10.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "asm-lsp";
    rev = "v${version}";
    hash = "sha256-vEilIoIK6fxZBhmyDueP2zvbh1/t2wd4cnq/0y6p+TI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  cargoHash = "sha256-D91n+sx8qwkn/rEWP5ftS/mhmRru43TmKZUyvAc47H0=";

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
