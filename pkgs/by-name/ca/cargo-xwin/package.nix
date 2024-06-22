{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-3vQ7pM7Ui0H6qWFWOCW4LzDLJq8bcoFEJrpoa4Tzk9g=";
  };

  cargoHash = "sha256-4uWPbwntcD4YKdjTlWfMGqM+rddKzaXH1YTX9qLrWrY=";

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
