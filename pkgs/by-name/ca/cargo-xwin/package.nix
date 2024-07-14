{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-lz1IykhdJy3540g6A5EpxGM2czM5psi/zZdKkgJd7BA=";
  };

  cargoHash = "sha256-qKLHrHQhjWysvOwVvlCjaQOoidUz42wEyJPyo/nz5Ro=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
