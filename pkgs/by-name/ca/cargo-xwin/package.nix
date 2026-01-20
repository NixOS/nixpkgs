{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-GQV8Sy7BCkPGYusojZGQtaazTXONdJIZ4B4toO1Lj/w=";
  };

  cargoHash = "sha256-fVr5W5xpucqUyKpDcubAh6GkB0roJ548EHgaIzqVJl0=";

  meta = {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
}
