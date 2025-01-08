{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-JwN0eUtj2qa5Hdl4aeDr9FtEpTB/Y36/q8ValfuvN/A=";
  };

  cargoHash = "sha256-pHy5sImtaN5MzkewygFbPK1yFLRmHrzPDa7NOoUoA5M=";

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
